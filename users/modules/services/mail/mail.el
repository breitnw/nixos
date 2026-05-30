;; -*- lexical-binding: t -*-

;; This file holds mu4e configuration relating to the remote server and
;; maildirs. Any behavior that is exclusive to the client (e.g., appearance) is
;; configured in my Doom Emacs config.

(after! mu4e
  (defvar mail-accounts) ;; set by nix config

  ;; add bookmark for all inboxes
  (setq mu4e-bookmarks
        `((:name "All inboxes"
           :query ,(format
                    "(%s)"
                    (mapconcat
                     (lambda (account)
                       (format "maildir:/%s/Inbox" (car account)))
                     mail-accounts
                     " OR "))
           :key ?i)
          (:name "Unread messages"
           :query "flag:unread"
           :key ?u)
          (:name "Today's messages"
           :query "date:today..now"
           :key ?t)))


  ;; don't add the trash flag, because this seems to mess up trash folder behavior
  (setq mu4e-trash-without-flag t)

  ;; fix trash behavior for gmail
  ;; TODO ideally, this should only happen for gmail accounts
  (setf (alist-get 'move mu4e-marks)
        '(:char ("m" . "▷") :prompt "move" :ask-target mu4e--mark-get-move-target
          ;; Here's the main difference to the regular trash mark, no +T
          ;; before -N so the message is not marked as IMAP-deleted:
          :action (lambda (docid msg target)
                    (mu4e--server-move docid
                                       (mu4e--mark-check-target target) "+S-u-N"))))

  ;; avoid mail syncing issues when using mbsync
  (setq mu4e-change-filenames-when-moving t)

  ;; don't save message to Sent Messages, Gmail/IMAP takes care of this
  (setq mu4e-sent-messages-behavior 'delete)

  ;; send messages with msmtp
  (setq send-mail-function 'smtpmail-send-it
        message-sendmail-f-is-evil t
        ;; mail-user-agent 'sendmail-user-agent
        sendmail-program (executable-find "msmtp")
        message-sendmail-extra-arguments '("--read-envelope-from")
        message-send-mail-function 'message-send-mail-with-sendmail)

  ;; select the right sender email from the context.
  (setq message-sendmail-envelope-from 'header)

  ;; refresh mail with mbsync
  (setq mu4e-update-interval nil
        mu4e-get-mail-command "mbsync -a"
        mu4e-root-maildir "~/Mail")

  ;; mu4e-context
  (setq mu4e-context-policy 'pick-first)
  (setq mu4e-compose-context-policy 'always-ask)
  ;; use said accounts to create mu4e contexts
  (setq mu4e-contexts
        (mapcar
         (lambda (account)
           (let ((acc-name (car account))
                 (acc-address (cdr account)))
             (make-mu4e-context
              :name acc-name
              :enter-func
              (lambda () (mu4e-message (concat "Entered " acc-name " context")))
              :match-func
              (lambda (msg)
                (when msg
                  (string-prefix-p (format "/%s" acc-name) (mu4e-message-field msg :maildir))))
              :vars
              `((user-mail-address  . ,acc-address)
                (smtpmail-smtp-user . ,acc-address)
                (mu4e-compose-signature . "Nick Breitling")
                (user-full-name     . "Nick Breitling")
                (mu4e-drafts-folder . ,(format "/%s/Drafts" acc-name))
                (mu4e-trash-folder  . ,(format "/%s/Trash" acc-name))
                (mu4e-sent-folder   . ,(format "/%s/Sent" acc-name))
                (mu4e-maildir-shortcuts . ((,(format "/%s/Inbox" acc-name)   . ?i)
                                           (,(format "/%s/Sent" acc-name)    . ?s)
                                           (,(format "/%s/Drafts" acc-name)  . ?d)
                                           (,(format "/%s/Spam" acc-name)    . ?p)
                                           (,(format "/%s/Trash" acc-name)   . ?t)))
                (smtpmail-smtp-server . "smtp.gmail.com")
                (smtpmail-default-smtp-server . "smtp.gmail.com")
                (smtpmail-local-domain . "gmail.com")))))
         mail-accounts)))

(after! mu4e
  ;; appearance tweak: instead of the ugly highlight do blue arrows
  (set-face-attribute 'mu4e-highlight-face nil :inherit 'nerd-icons-blue)

  (setq mu4e-headers-thread-blank-prefix '("  " . "  ")
        mu4e-headers-thread-child-prefix '("├─" . "├─")
        mu4e-headers-thread-connection-prefix '("│ " . "│ ")
        mu4e-headers-thread-duplicate-prefix '("= " . "= ")
        mu4e-headers-thread-first-child-prefix '("├─" . "├─")
        mu4e-headers-thread-last-child-prefix '("└─" . "└─")
        mu4e-headers-thread-orphan-prefix '("┬─" . "┬─")
        mu4e-headers-thread-root-prefix '("□ " . "□ ")
        mu4e-headers-thread-single-orphan-prefix '("── " . "── "))

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

  ;; refresh mail every 5 minutes
  (setq mu4e-update-interval (* 5 60)
        mu4e-get-mail-command "mbsync -a"
        mu4e-root-maildir "~/Mail")

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

# Testing
node --max_old_space_size=8096 node_modules/@angular/cli/bin/ng test --browsers ChromeHeadless
# Magit
magit-status
# Emacs
C-H for help, f is describe function
# org mode
https://www.sastibe.de/2018/11/take-screenshots-straight-into-org-files-in-emacs-on-win10/
;;
;; My Function for Screenshots
;;
```elisp
(defun my-org-screenshot ()
  "Take a screenshot into a time stamped unique-named file in the
same directory as the org-buffer and insert a link to this file."
  (interactive)
  (setq filename
        (concat
         (make-temp-name
          (concat (buffer-file-name)
                  "_"
                  (format-time-string "%Y%m%d_%H%M%S_")) ) ".png"))
  (shell-command "snippingtool /clip")
  (shell-command (concat "powershell -command \"Add-Type -AssemblyName System.Windows.Forms;if ($([System.Windows.Forms.Clipboard]::ContainsImage())) {$image = [System.Windows.Forms.Clipboard]::GetImage();[System.Drawing.Bitmap]$image.Save('" filename "',[System.Drawing.Imaging.ImageFormat]::Png); Write-Output 'clipboard content saved as file'} else {Write-Output 'clipboard does not contain image data'}\""))
  (insert (concat "[[file:" filename "]]"))
  (org-display-inline-images))

(global-set-key "\C-cs" 'my-org-screenshot)
```

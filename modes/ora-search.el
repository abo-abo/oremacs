(require 'hydra)

(defun ora-search-query (fmt)
  (let ((query (read-from-minibuffer "Search for: ")))
    (browse-url (format fmt query))))

(defhydra hydra-search (:exit t)
  ("g" (ora-search-query "https://github.com/search?ref=simplesearch&q=%s") "github")
  ("m" (ora-search-query "https://www.google.com/maps/search/%s?hl=en&source=opensearch") "maps")
  ("r" (ora-search-query "https://www.reddit.com/search?q=%s") "reddit")
  ("t" (ora-search-query "https://twitter.com/search?q=%s") "twitter")
  ("T" (browse-url "https://www.google.com/travel") "travel")
  ("y" (ora-search-query "https://www.youtube.com/results?search_query=%s&page={startPage?}&utm_source=opensearch") "youtube")
  ("q" nil "quit"))

(provide 'ora-search)

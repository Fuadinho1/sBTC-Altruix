
;; sBTC-Altruix

;; constants
;;
(define-constant ERR_UNAUTHORIZED (err u1))
(define-constant ERR_INVALID_AMOUNT (err u2))
(define-constant ERR_INSUFFICIENT_FUNDS (err u3))
(define-constant ERR_RECIPIENT_NOT_FOUND (err u4))
(define-constant ERR_RECIPIENT_EXISTS (err u5))
(define-constant ERR_NOT_CONFIRMED (err u8))
(define-constant ERR_UNCHANGED_STATE (err u9))
(define-constant withdrawal-cooldown u86400) ;; 24 hours in seconds

;; data maps and vars
;;
(define-data-var total-funds uint u0)
(define-data-var admin principal tx-sender)
(define-data-var min-donation uint u1)
(define-data-var max-donation uint u1000000000)
(define-data-var paused bool false)

;; Maps
(define-map donations principal uint)
(define-map recipients principal uint)
(define-map last-withdrawal principal uint)




(define-read-only (get-donation (user principal))
  (default-to u0 (map-get? donations user))
)

(define-read-only (get-total-funds)
  (ok (var-get total-funds))
)

(define-read-only (is-paused)
  (ok (var-get paused))
)

(define-read-only (get-recipient-allocation (recipient principal))
  (ok (default-to u0 (map-get? recipients recipient)))
)

(define-read-only (get-admin)
  (ok (var-get admin))
)

(define-read-only (get-user-history (user principal))
  ;; Return donation and withdrawal records for a user
  (ok (tuple (donations (map-get? donations user)) (withdrawals (map-get? last-withdrawal user))))
)



;; private functions
(define-private (distribute-to-recipient (recipient-data {recipient: principal, allocation: uint}))
  (let ((recipient (get recipient recipient-data))
        (allocation (get allocation recipient-data)))
    (try! (as-contract (stx-transfer? allocation tx-sender recipient)))
    (print {event: "funds-sent", recipient: recipient, amount: allocation})
    (ok true)
  )
)


;; public functions
;;
(define-public (donate (amount uint))
  (if (and (not (var-get paused))
           (>= amount (var-get min-donation))
           (<= amount (var-get max-donation)))
    (begin
      (map-set donations tx-sender (+ (get-donation tx-sender) amount))
      (var-set total-funds (+ (var-get total-funds) amount))
      (print {event: "donation", sender: tx-sender, amount: amount})
      (ok amount)
    )
    (err u100) ;; Error: Invalid donation amount or contract paused
  )
)

;; Prescriber Verification Contract
;; This contract validates authorized healthcare providers

;; Define admin
(define-data-var admin principal tx-sender)

;; Map of verified prescribers
(define-map prescribers
  { id: (string-ascii 32) }
  {
    name: (string-ascii 100),
    license: (string-ascii 50),
    status: (string-ascii 10)
  }
)

;; Register a new prescriber
(define-public (register-prescriber
    (id (string-ascii 32))
    (name (string-ascii 100))
    (license (string-ascii 50))
  )
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (ok (map-set prescribers
      { id: id }
      {
        name: name,
        license: license,
        status: "pending"
      }
    ))
  )
)

;; Verify a prescriber
(define-public (verify-prescriber (id (string-ascii 32)))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (asserts! (is-some (map-get? prescribers { id: id })) (err u404))

    (ok (map-set prescribers
      { id: id }
      (merge (unwrap! (map-get? prescribers { id: id }) (err u404))
        { status: "verified" }
      )
    ))
  )
)

;; Suspend a prescriber
(define-public (suspend-prescriber (id (string-ascii 32)))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (asserts! (is-some (map-get? prescribers { id: id })) (err u404))

    (ok (map-set prescribers
      { id: id }
      (merge (unwrap! (map-get? prescribers { id: id }) (err u404))
        { status: "suspended" }
      )
    ))
  )
)

;; Check if a prescriber is verified
(define-read-only (is-verified (id (string-ascii 32)))
  (let (
    (prescriber (map-get? prescribers { id: id }))
  )
    (if (is-some prescriber)
      (is-eq (get status (unwrap! prescriber false)) "verified")
      false
    )
  )
)

;; Get prescriber details
(define-read-only (get-prescriber (id (string-ascii 32)))
  (map-get? prescribers { id: id })
)


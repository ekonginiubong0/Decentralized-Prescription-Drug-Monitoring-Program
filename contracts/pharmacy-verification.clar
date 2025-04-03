;; Pharmacy Verification Contract
;; This contract confirms legitimate dispensing facilities

;; Define admin
(define-data-var admin principal tx-sender)

;; Map of verified pharmacies
(define-map pharmacies
  { id: (string-ascii 32) }
  {
    name: (string-ascii 100),
    license: (string-ascii 50),
    address: (string-ascii 100),
    status: (string-ascii 10)
  }
)

;; Register a new pharmacy
(define-public (register-pharmacy
    (id (string-ascii 32))
    (name (string-ascii 100))
    (license (string-ascii 50))
    (address (string-ascii 100))
  )
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (ok (map-set pharmacies
      { id: id }
      {
        name: name,
        license: license,
        address: address,
        status: "pending"
      }
    ))
  )
)

;; Verify a pharmacy
(define-public (verify-pharmacy (id (string-ascii 32)))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (asserts! (is-some (map-get? pharmacies { id: id })) (err u404))

    (ok (map-set pharmacies
      { id: id }
      (merge (unwrap! (map-get? pharmacies { id: id }) (err u404))
        { status: "verified" }
      )
    ))
  )
)

;; Suspend a pharmacy
(define-public (suspend-pharmacy (id (string-ascii 32)))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))
    (asserts! (is-some (map-get? pharmacies { id: id })) (err u404))

    (ok (map-set pharmacies
      { id: id }
      (merge (unwrap! (map-get? pharmacies { id: id }) (err u404))
        { status: "suspended" }
      )
    ))
  )
)

;; Check if a pharmacy is verified
(define-read-only (is-verified (id (string-ascii 32)))
  (let (
    (pharmacy (map-get? pharmacies { id: id }))
  )
    (if (is-some pharmacy)
      (is-eq (get status (unwrap! pharmacy false)) "verified")
      false
    )
  )
)

;; Get pharmacy details
(define-read-only (get-pharmacy (id (string-ascii 32)))
  (map-get? pharmacies { id: id })
)


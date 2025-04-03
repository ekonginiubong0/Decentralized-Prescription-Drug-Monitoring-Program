;; Prescription Tracking Contract
;; This contract monitors controlled substance prescriptions

;; Define admin
(define-data-var admin principal tx-sender)

;; Define prescription status constants
(define-constant STATUS_ACTIVE "active")
(define-constant STATUS_FILLED "filled")
(define-constant STATUS_CANCELLED "cancelled")

;; Map of prescriptions
(define-map prescriptions
  { id: (string-ascii 32) }
  {
    prescriber: (string-ascii 32),
    patient: (string-ascii 32),
    medication: (string-ascii 100),
    dosage: (string-ascii 50),
    quantity: uint,
    refills: uint,
    refills-used: uint,
    status: (string-ascii 10)
  }
)

;; Map to track patient prescriptions
(define-map patient-prescriptions
  { patient: (string-ascii 32) }
  { prescription-list: (list 100 (string-ascii 32)) }
)

;; Create a new prescription
(define-public (create-prescription
    (id (string-ascii 32))
    (prescriber (string-ascii 32))
    (patient (string-ascii 32))
    (medication (string-ascii 100))
    (dosage (string-ascii 50))
    (quantity uint)
    (refills uint)
  )
  (let (
    (patient-history (default-to { prescription-list: (list) }
                     (map-get? patient-prescriptions { patient: patient })))
  )
    ;; Only admin can create prescriptions in this simplified version
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))

    ;; Create the prescription
    (map-set prescriptions
      { id: id }
      {
        prescriber: prescriber,
        patient: patient,
        medication: medication,
        dosage: dosage,
        quantity: quantity,
        refills: refills,
        refills-used: u0,
        status: STATUS_ACTIVE
      }
    )

    ;; Update patient prescription history
    (map-set patient-prescriptions
      { patient: patient }
      { prescription-list: (unwrap! (as-max-len?
                           (append (get prescription-list patient-history) id)
                           u100)
                           (err u413)) }
    )

    (ok true)
  )
)

;; Fill a prescription
(define-public (fill-prescription
    (id (string-ascii 32))
    (pharmacy (string-ascii 32))
  )
  (let (
    (prescription (unwrap! (map-get? prescriptions { id: id }) (err u404)))
  )
    ;; Only admin can fill prescriptions in this simplified version
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))

    ;; Check prescription is active
    (asserts! (is-eq (get status prescription) STATUS_ACTIVE) (err u403))

    ;; Check refills available
    (asserts! (< (get refills-used prescription) (get refills prescription)) (err u412))

    ;; Update prescription
    (map-set prescriptions
      { id: id }
      (merge prescription {
        refills-used: (+ (get refills-used prescription) u1),
        status: (if (>= (+ (get refills-used prescription) u1) (get refills prescription))
                  STATUS_FILLED
                  STATUS_ACTIVE)
      })
    )

    (ok true)
  )
)

;; Cancel a prescription
(define-public (cancel-prescription (id (string-ascii 32)))
  (let (
    (prescription (unwrap! (map-get? prescriptions { id: id }) (err u404)))
  )
    ;; Only admin can cancel prescriptions in this simplified version
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))

    ;; Update prescription status
    (map-set prescriptions
      { id: id }
      (merge prescription {
        status: STATUS_CANCELLED
      })
    )

    (ok true)
  )
)

;; Get prescription details
(define-read-only (get-prescription (id (string-ascii 32)))
  (map-get? prescriptions { id: id })
)

;; Get patient prescription history
(define-read-only (get-patient-prescriptions (patient (string-ascii 32)))
  (map-get? patient-prescriptions { patient: patient })
)


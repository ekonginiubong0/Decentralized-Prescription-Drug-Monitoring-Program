;; Alert System Contract
;; This contract identifies potential abuse patterns

;; Define admin
(define-data-var admin principal tx-sender)

;; Define alert types
(define-constant ALERT_MULTIPLE_PRESCRIBERS "multiple")
(define-constant ALERT_FREQUENT_REFILLS "frequent")

;; Map of alerts
(define-map alerts
  { id: (string-ascii 32) }
  {
    type: (string-ascii 20),
    patient: (string-ascii 32),
    description: (string-ascii 200),
    status: (string-ascii 10)
  }
)

;; Map to track patient alerts
(define-map patient-alerts
  { patient: (string-ascii 32) }
  { alert-list: (list 100 (string-ascii 32)) }
)

;; Create a new alert
(define-public (create-alert
    (id (string-ascii 32))
    (alert-type (string-ascii 20))
    (patient (string-ascii 32))
    (description (string-ascii 200))
  )
  (let (
    (patient-history (default-to { alert-list: (list) }
                     (map-get? patient-alerts { patient: patient })))
  )
    ;; Only admin can create alerts in this simplified version
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))

    ;; Create the alert
    (map-set alerts
      { id: id }
      {
        type: alert-type,
        patient: patient,
        description: description,
        status: "active"
      }
    )

    ;; Update patient alert history
    (map-set patient-alerts
      { patient: patient }
      { alert-list: (unwrap! (as-max-len?
                    (append (get alert-list patient-history) id)
                    u100)
                    (err u413)) }
    )

    (ok true)
  )
)

;; Create multiple prescriber alert
(define-public (create-multiple-prescriber-alert
    (id (string-ascii 32))
    (patient (string-ascii 32))
  )
  (create-alert
    id
    ALERT_MULTIPLE_PRESCRIBERS
    patient
    "Patient received prescriptions from multiple prescribers"
  )
)

;; Create frequent refill alert
(define-public (create-frequent-refill-alert
    (id (string-ascii 32))
    (patient (string-ascii 32))
  )
  (create-alert
    id
    ALERT_FREQUENT_REFILLS
    patient
    "Patient requested frequent refills"
  )
)

;; Resolve an alert
(define-public (resolve-alert (id (string-ascii 32)))
  (let (
    (alert (unwrap! (map-get? alerts { id: id }) (err u404)))
  )
    ;; Only admin can resolve alerts
    (asserts! (is-eq tx-sender (var-get admin)) (err u403))

    ;; Update alert status
    (map-set alerts
      { id: id }
      (merge alert {
        status: "resolved"
      })
    )

    (ok true)
  )
)

;; Get alert details
(define-read-only (get-alert (id (string-ascii 32)))
  (map-get? alerts { id: id })
)

;; Get patient alert history
(define-read-only (get-patient-alerts (patient (string-ascii 32)))
  (map-get? patient-alerts { patient: patient })
)


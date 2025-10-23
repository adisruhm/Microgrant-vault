;; -----------------------------------------------------
;; MicroGrant Vault
;; -----------------------------------------------------
;; A decentralized STX-based vault that funds micro-projects
;; through community voting and transparent distribution.
;; -----------------------------------------------------
;; Author: [Your Name]
;; For: Stacks Code-for-STX Initiative
;; -----------------------------------------------------

(define-constant ERR-UNAUTHORIZED (err u100))
(define-constant ERR-INVALID-AMOUNT (err u101))
(define-constant ERR-NO-PROPOSAL (err u102))
(define-constant ERR-VOTING-CLOSED (err u103))
(define-constant ERR-ALREADY-FUNDED (err u104))

(define-data-var vault-balance uint u0)
(define-data-var proposal-count uint u0)

;; Store details of each vault participant
(define-map contributors
  { user: principal }
  { amount: uint }
)

;; Store proposals
(define-map proposals
  { id: uint }
  {
    title: (string-ascii 50),
    description: (string-ascii 200),
    proposer: principal,
    requested: uint,
    votes: uint,
    is-funded: bool,
    deadline: uint
  }
)

;; -----------------------------------------------------
;; Deposit Function
;; -----------------------------------------------------

(define-public (deposit (amount uint))
  (begin
    (asserts! (> amount u0) ERR-INVALID-AMOUNT)
    ;; Fixed contract-call syntax and wrapped stx-transfer with try!
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
    (var-set vault-balance (+ (var-get vault-balance) amount))
    (map-set contributors {user: tx-sender} {amount: amount})
    (ok "Deposit successful.")
  )
)

;; -----------------------------------------------------
;; Create Proposal
;; -----------------------------------------------------

(define-public (create-proposal (title (string-ascii 50)) (desc (string-ascii 200)) (amount uint) (duration uint))
  (let ((id (+ (var-get proposal-count) u1)))
    (var-set proposal-count id)
    (map-set proposals {id: id}
      {
        title: title,
        description: desc,
        proposer: tx-sender,
        requested: amount,
        votes: u0,
        is-funded: false,
        deadline: (+ stacks-block-height duration)
      })
    (ok (tuple (proposal-id id) (status "Created")))
  )
)

;; -----------------------------------------------------
;; Voting
;; -----------------------------------------------------

(define-public (vote (proposal-id uint) (weight uint))
  (let ((proposal (map-get? proposals {id: proposal-id})))
    (match proposal p
      (if (<= stacks-block-height (get deadline p))
          (begin
            (map-set proposals {id: proposal-id}
              (merge p {votes: (+ (get votes p) weight)}))
            (ok "Vote recorded."))
          ERR-VOTING-CLOSED)
      ERR-NO-PROPOSAL))
)

;; -----------------------------------------------------
;; Fund Winning Proposal
;; -----------------------------------------------------

(define-public (fund-proposal (proposal-id uint))
  (let ((proposal (map-get? proposals {id: proposal-id})))
    (match proposal p
      (if (and (not (get is-funded p)) (>= (get votes p) u10))
          (begin
            ;; Wrapped stx-transfer with try! to check response
            (try! (as-contract (stx-transfer? (get requested p) tx-sender (get proposer p))))
            (map-set proposals {id: proposal-id} (merge p {is-funded: true}))
            (var-set vault-balance (- (var-get vault-balance) (get requested p)))
            (ok "Proposal funded."))
          ERR-ALREADY-FUNDED)
      ERR-NO-PROPOSAL))
)

;; -----------------------------------------------------
;; Read-Only Functions
;; -----------------------------------------------------

(define-read-only (get-proposal (id uint))
  (map-get? proposals {id: id})
)

(define-read-only (get-balance)
  (var-get vault-balance)
)

(define-read-only (get-contributor (user principal))
  (map-get? contributors {user: user})
)

(define-read-only (get-proposal-count)
  (var-get proposal-count)
)

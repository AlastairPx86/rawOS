; Performs the sha 256 hash
; INPUT: si = db variable to hash;
; OUTPUT: si = hash IN STRING FORMAT (db)
ros_crypto_sha256:
    ; Difine constants
    pusha
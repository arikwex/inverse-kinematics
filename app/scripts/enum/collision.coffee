collision = {}

collision.GROUND = 0x1
collision.MUSCLE = 0x2
collision.MUSCLE_FRONT = 0x4
collision.MUSCLE_BACK = 0x8
collision.SKIN = 0x10

collision.ALL = collision.GROUND |
                collision.MUSCLE |
                collision.MUSCLE_FRONT |
                collision.MUSCLE_BACK

module.exports = collision
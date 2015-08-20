collision = {}

collision.GROUND = 0x1
collision.MUSCLE = 0x2
collision.MUSCLE_FRONT = 0x4
collision.MUSCLE_FRONT2 = 0x8
collision.MUSCLE_MIDDLE = 0x10
collision.MUSCLE_BACK = 0x20
collision.MUSCLE_BACK2 = 0x40
collision.SKIN = 0x80

collision.ALL = collision.GROUND |
                collision.MUSCLE |
                collision.MUSCLE_FRONT |
                collision.MUSCLE_BACK |
                collision.MUSCLE_MIDDLE |
                collision.MUSCLE_FRONT2 |
                collision.MUSCLE_BACK2

module.exports = collision
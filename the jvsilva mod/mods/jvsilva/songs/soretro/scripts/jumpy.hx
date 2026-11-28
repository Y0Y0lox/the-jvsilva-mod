var groundY:Float = 0;
var velocityY:Float = 0;
var isGrounded:Bool = true;

var baseScaleX:Float = 1;
var baseScaleY:Float = 1;
var baseHeight:Float = 0;

function postCreate() {
    groundY = boyfriend.y;
    baseScaleX = boyfriend.scale.x;
    baseScaleY = boyfriend.scale.y;
    baseHeight = boyfriend.height;
}

function update(elapsed:Float) {
    // Move Left (A)
    if (FlxG.keys.pressed.A) {
        boyfriend.x -= 600 * elapsed;
    }

    // Move Right (L)
    if (FlxG.keys.pressed.L) {
        boyfriend.x += 600 * elapsed;
    }

    // Jump (K) + Play Down Animation
    if (FlxG.keys.justPressed.K && isGrounded) {
        velocityY = -750;
        isGrounded = false;
        boyfriend.playAnim("singDOWN", true);
    }

    // Apply Gravity & Vertical Movement
    if (!isGrounded) {
        velocityY += 1800 * elapsed;
        boyfriend.y += velocityY * elapsed;

        if (boyfriend.y >= groundY) {
            boyfriend.y = groundY;
            velocityY = 0;
            isGrounded = true;
        }
    }

    // Squish when holding S (only while on the ground)
    if (FlxG.keys.pressed.S && isGrounded) {
        boyfriend.scale.set(baseScaleX * 1.15, baseScaleY * 0.75);
        boyfriend.y = groundY + (baseHeight * 0.125);
    } else if (isGrounded) {
        boyfriend.scale.set(baseScaleX, baseScaleY);
        boyfriend.y = groundY;
    }

    if(FlxG.keys.justPressed.SPACE)
    {
        boyfriend.flipX = !boyfriend.flipX;
    }
}
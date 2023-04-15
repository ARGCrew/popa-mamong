package;

class Utils {
    public static function boundTo(value:Int, minValue:Int, maxValue:Int):Int {
        if (value < minValue) {
            value = maxValue;
        }
        if (value > maxValue) {
            value = minValue;
        }

        return value;
    }
}
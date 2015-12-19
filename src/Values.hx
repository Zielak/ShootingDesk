
class Values
{

    var values:ChanceValue;
    var ranges:ChanceRange;

    public function new(ranges:ChanceRange, values:ChanceValue)
    {
        this.ranges = ranges;
        this.values = values;
    }

    public function result(dice:Int)
    {
        if( ranges.miss.indexOf(dice) > -1 ){

            return values.miss;

        }else if( ranges.hit.indexOf(dice) > -1 ){

            return values.hit;

        }else if( ranges.crit.indexOf(dice) > -1 ){

            return values.crit;

        }

        return -1;
    }

}

typedef ChanceRange = {
    var miss:Array<Int>;
    var hit:Array<Int>;
    var crit:Array<Int>;
}

typedef ChanceValue = {
    var miss:Int;
    var hit:Int;
    var crit:Int;
}

/// Class for calcualting difference between now and inDue datetime
class OurTimeLeft {
  /// Calculates difference between now and iDue datetimes
  List<String> timeLeft(DateTime inDue) {
    List<String> retVal = List(2);

    /// -------- Due date -------------

    /// _timeUntilDue = inDue - now
    Duration _timeUntilDue = inDue.difference(DateTime.now());

    /// Convert it to day, hours, mins and seconds
    int _daysUntilDue = _timeUntilDue.inDays;
    int _hoursUntilDue = _timeUntilDue.inHours - (_daysUntilDue * 24);
    int _minUntilDue = _timeUntilDue.inMinutes -
        (_daysUntilDue * 24 * 60) -
        (_hoursUntilDue * 60);
    int _secUntilDue = _timeUntilDue.inSeconds -
        (_daysUntilDue * 24 * 60 * 60) -
        (_hoursUntilDue * 60 * 60) -
        (_minUntilDue * 60);

    /// ------ Revealed date ---------------

    /// _timeUntilReveal = inDue - 7 days - now
    Duration _timeUntilReveal =
        inDue.subtract(Duration(days: 7)).difference(DateTime.now());

    /// Convert it to day, hours, mins and seconds
    int _daysUntilReveal = _timeUntilReveal.inDays;
    int _hoursUntilReveal = _timeUntilReveal.inHours - (_daysUntilReveal * 24);
    int _minUntilReveal = _timeUntilReveal.inMinutes -
        (_daysUntilReveal * 24 * 60) -
        (_hoursUntilReveal * 60);
    int _secUntilReveal = _timeUntilReveal.inSeconds -
        (_daysUntilReveal * 24 * 60 * 60) -
        (_hoursUntilReveal * 60 * 60) -
        (_minUntilReveal * 60);

    /// Set the return values
    if (_daysUntilDue >= 0) {
      retVal[0] =
          "$_daysUntilDue days\n$_hoursUntilDue:$_minUntilDue:$_secUntilDue";
    } else {
      retVal[0] = "Time is up!";
    }

    if (_daysUntilReveal >= 0) {
      retVal[1] =
          "$_daysUntilReveal days\n$_hoursUntilReveal:$_minUntilReveal:$_secUntilReveal";
    } else {
      retVal[1] = "Revealed!";
    }
    return retVal;
  }
}

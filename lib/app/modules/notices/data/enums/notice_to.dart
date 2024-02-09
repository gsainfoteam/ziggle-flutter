enum NoticeTo {
  all,
  reminder;

  factory NoticeTo.fromBoolean(bool toAll) {
    return toAll ? NoticeTo.all : NoticeTo.reminder;
  }
}

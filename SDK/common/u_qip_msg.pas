unit u_qip_msg;

interface

type
  TQipMessage = record
    Msg    : Cardinal;
    WParam : Longint;
    LParam : Longint;
    Result : Longint;
  end;

const
  nilTQipMessage: TQipMessage = ();

implementation

end.

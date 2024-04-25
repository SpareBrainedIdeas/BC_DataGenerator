codeunit 80800 "SPB DataGen Utilities"
{
    SingleInstance = true;
    Access = Internal;

    procedure SafeName(InputText: Text) OutputText: Text
    var
        preserveChars: Text;
    begin
        OutputText := ConvertDigitsToWords(InputText);
        preserveChars := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
        OutputText := DelChr(OutputText, '=', DELCHR(OutputText, '=', preserveChars));
    end;

    procedure ConvertDigitsToWords(InputText: Text) OutputText: Text;
    begin
        // Kludge but eh
        OutputText := InputText.Replace('10', 'Ten');
        OutputText := OutputText.Replace('1', 'One');
        OutputText := OutputText.Replace('2', 'Two');
        OutputText := OutputText.Replace('3', 'Three');
        OutputText := OutputText.Replace('4', 'Four');
        OutputText := OutputText.Replace('5', 'Five');
        OutputText := OutputText.Replace('6', 'Six');
        OutputText := OutputText.Replace('7', 'Seven');
        OutputText := OutputText.Replace('8', 'Eight');
        OutputText := OutputText.Replace('9', 'Nine');
    end;


    procedure ALSafeDate(InputDate: Date) OutputText: Text
    begin
        if InputDate = 0D then
            exit('0D');
        OutputText := Format(InputDate, 0, '<Year4><Month,2><Day,2>') + 'D';
    end;

    procedure ALSafeTime(InputTime: Time) OutputText: Text
    begin
        if InputTime = 0T then
            exit('0T');
        OutputText := Format(InputTime, 0, '<Hours24,2><Minutes,2><Seconds,2>') + 'T';
    end;

    procedure ALSafeDateTime(InputDateTime: DateTime) OutputText: Text
    begin
        if InputDatetime = 0DT then
            exit('0DT');
        OutputText := 'CreateDateTime(' + Format(InputDateTime, 0, '<Year4><Month,2><Day,2>') + 'D, ' + Format(InputDateTime, 0, '<Hours24,2><Minutes,2><Seconds,2>') + 'T)';
    end;

    procedure ALSafeGuid(InputGuid: Guid) OutputText: Text
    begin
        OutputText := 'TextAsGuid(''' + Format(InputGuid) + ''')';
    end;

    procedure TextAsGuid(InputText: Text) OutputGuid: Guid
    begin
        Evaluate(OutputGuid, InputText);
    end;

    procedure ALSafeDateFormula(InputDateFormula: DateFormula) OutputText: Text
    begin
        OutputText := 'TextAsDateFormula(''' + Format(InputDateFormula) + ''')';
    end;

    procedure TextAsDateFormula(InputText: Text) OutputDateFormula: DateFormula
    begin
        Evaluate(OutputDateFormula, InputText);
    end;

    /* Functions lifted from "Library - Random" from Business Central test toolkit */
    #region LibraryRandomFunctions
    var
        Seed: Integer;

    procedure RandDec(Range: Integer; Decimals: Integer): Decimal
    begin
        exit(RandInt(Range * Power(10, Decimals)) / Power(10, Decimals));
    end;

    procedure RandDecInRange("Min": Integer; "Max": Integer; Decimals: Integer): Decimal
    begin
        // Returns a pseudo random decimal in the interval (Min,Max]
        exit(Min + RandDec(Max - Min, Decimals));
    end;

    procedure RandDecInDecimalRange("Min": Decimal; "Max": Decimal; Precision: Integer): Decimal
    var
        Min2: Integer;
        Max2: Integer;
        Pow: Integer;
    begin
        Pow := Power(10, Precision);
        Min2 := Round(Min * Pow, 1, '>');
        Max2 := Round(Max * Pow, 1, '<');
        exit(RandIntInRange(Min2, Max2) / Pow);
    end;

    procedure RandInt(Range: Integer): Integer
    begin
        // Returns a pseudo random integer in the interval [1,Range]
        if Range < 1 then
            exit(1);
        exit(1 + Round(Uniform * (Range - 1), 1));
    end;

    procedure RandIntInRange("Min": Integer; "Max": Integer): Integer
    begin
        exit(Min - 1 + RandInt(Max - Min + 1));
    end;

    procedure RandDate(Delta: Integer): Date
    begin
        if Delta = 0 then
            exit(WorkDate);
        exit(CalcDate(StrSubstNo('<%1D>', Delta / Abs(Delta) * RandInt(Abs(Delta))), WorkDate));
    end;

    procedure RandDateFrom(FromDate: Date; Range: Integer): Date
    begin
        if Range = 0 then
            exit(FromDate);
        exit(CalcDate(StrSubstNo('<%1D>', Range / Abs(Range) * RandInt(Range)), FromDate));
    end;

    procedure RandDateFromInRange(FromDate: Date; FromRange: Integer; ToRange: Integer): Date
    begin
        if FromRange >= ToRange then
            exit(FromDate);
        exit(CalcDate(StrSubstNo('<+%1D>', RandIntInRange(FromRange, ToRange)), FromDate));
    end;

    procedure RandPrecision(): Decimal
    begin
        exit(1 / Power(10, RandInt(5)));
    end;

    procedure Init(): Integer
    begin
        // Updates the seed from the current time
        exit(SetSeed(Time - 000000T));
    end;

    procedure SetSeed(Val: Integer): Integer
    begin
        // Set the random seed to reproduce pseudo random sequence
        Seed := Val;
        Seed := Seed mod 10000;  // Overflow protection
        exit(Seed);
    end;

    local procedure UpdateSeed()
    begin
        // Generates a new seed value and
        Seed := Seed + 3;
        Seed := Seed * 3;
        Seed := Seed * Seed;
        Seed := Seed mod 10000;  // Overflow protection
    end;

    local procedure Uniform(): Decimal
    begin
        // Generates a pseudo random uniform number
        UpdateSeed;

        exit((Seed mod 137) / 137);
    end;
    #endregion LibraryRandomFunctions


    /* Functions lifted from "Library - Utility" from Business Central test toolkit */
    #region LibraryUtilityFunctions

    procedure GenerateRandomCode(FieldNo: Integer; TableNo: Integer): Code[10]
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // Create a random and unique code for the any code field.
        RecRef.Open(TableNo, true, CompanyName);
        Clear(FieldRef);
        FieldRef := RecRef.Field(FieldNo);

        repeat
            if FieldRef.Length < 10 then
                FieldRef.SetRange(CopyStr(GenerateGUID, 10 - FieldRef.Length + 1)) // Cut characters on the left side.
            else
                FieldRef.SetRange(GenerateGUID);
        until RecRef.IsEmpty;

        exit(FieldRef.GetFilter)
    end;

    procedure GenerateRandomCodeWithLength(FieldNo: Integer; TableNo: Integer; CodeLength: Integer): Code[10]
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
        NewCode: Code[10];
    begin
        // Create a random and unique code for the any code field.
        RecRef.Open(TableNo, false, CompanyName);
        Clear(FieldRef);
        FieldRef := RecRef.Field(FieldNo);
        repeat
            NewCode := CopyStr(GenerateRandomXMLText(CodeLength), 1, MaxStrLen(NewCode));
            FieldRef.SetRange(NewCode);
        until RecRef.IsEmpty;

        exit(NewCode);
    end;

    procedure GenerateRandomCode20(FieldNo: Integer; TableNo: Integer): Code[20]
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
    begin
        // Create a random and unique 20 code for the any code field.
        RecRef.Open(TableNo, false, CompanyName);
        Clear(FieldRef);
        FieldRef := RecRef.Field(FieldNo);
        repeat
            FieldRef.SetRange(PadStr(GenerateGUID, FieldRef.Length, '0'));
        until RecRef.IsEmpty;

        exit(FieldRef.GetFilter);
    end;

    procedure GenerateRandomText(Length: Integer) String: Text
    var
        i: Integer;
    begin
        // Create a random string of length <length>.
        for i := 1 to Length do
            String[i] := RandIntInRange(33, 126); // ASCII: ! (33) to ~ (126)

        exit(String)
    end;

    procedure GenerateRandomUnicodeText(Length: Integer) String: Text
    var
        i: Integer;
    begin
        // Create a random string of length <Length> with Unicode characters.
        for i := 1 to Length do
            String[i] := RandIntInRange(1072, 1103); // Cyrillic alphabet (to guarantee only printable chars)

        exit(String)
    end;

    procedure GenerateRandomXMLText(Length: Integer) String: Text
    var
        i: Integer;
        Number: Integer;
    begin
        // Create a random string of length <length> containing characters allowed by XML
        for i := 1 to Length do begin
            Number := RandIntInRange(0, 61);
            case Number of
                0 .. 9:
                    Number += 48; // 0-9
                10 .. 35:
                    Number += 65 - 10; // A-Z
                36 .. 61:
                    Number += 97 - 36; // a-z
            end;
            String[i] := Number;
        end;
    end;

    procedure GenerateRandomNumericText(Length: Integer) String: Text
    var
        i: Integer;
    begin
        for i := 1 to Length do
            String[i] := RandIntInRange(48, 57);
    end;

    procedure GenerateRandomAlphabeticText(Length: Integer; Option: Option Capitalized,Literal) String: Text
    var
        ASCIICodeFrom: Integer;
        ASCIICodeTo: Integer;
        Number: Integer;
        i: Integer;
    begin
        case Option of
            Option::Capitalized:
                begin
                    ASCIICodeFrom := 65;
                    ASCIICodeTo := 90;
                end;
            Option::Literal:
                begin
                    ASCIICodeFrom := 97;
                    ASCIICodeTo := 122;
                end;
            else
                exit;
        end;
        for i := 1 to Length do begin
            Number := RandIntInRange(ASCIICodeFrom, ASCIICodeTo);
            String[i] := Number;
        end;
    end;

    procedure GenerateRandomEmail(): Text[45]
    begin
        exit(GenerateRandomAlphabeticText(20, 1) + '@' + GenerateRandomAlphabeticText(20, 1) + '.' + GenerateRandomAlphabeticText(3, 1));
    end;

    procedure GenerateRandomEmails(): Text[80]
    begin
        exit(
            StrSubstNo('%1@%2.%3; ', GenerateRandomXMLText(10), GenerateRandomXMLText(10), GenerateRandomXMLText(3)) +
            StrSubstNo('%1@%2.%3; ', GenerateRandomXMLText(10), GenerateRandomXMLText(10), GenerateRandomXMLText(3)) +
            StrSubstNo('%1@%2.%3', GenerateRandomXMLText(10), GenerateRandomXMLText(10), GenerateRandomXMLText(3)));
    end;

    procedure GenerateRandomPhoneNo(): Text[20]
    var
        PlusSign: Text[1];
        OpenBracket: Text[1];
        CloseBracket: Text[1];
        Delimiter: Text[1];
    begin
        // +123 (456) 1234-1234
        // 123 456 12341234
        if RandInt(100) > 50 then begin
            PlusSign := '+';
            OpenBracket := '(';
            CloseBracket := ')';
            Delimiter := '-';
        end;
        exit(
            PlusSign + GenerateRandomNumericText(3) + ' ' +
            OpenBracket + GenerateRandomNumericText(3) + CloseBracket + ' ' +
            GenerateRandomNumericText(4) + Delimiter + GenerateRandomNumericText(4));
    end;

    procedure GenerateRandomFraction(): Decimal
    begin
        exit(RandInt(99) / 100);  // Generate any fraction between 0.01 to .99.
    end;

    procedure GenerateRandomDate(MinDate: Date; MaxDate: Date): Date
    var
        DateFormulaRandomDate: DateFormula;
        DateFormulaMinDate: DateFormula;
    begin
        Evaluate(DateFormulaMinDate, '<-1D>');
        Evaluate(DateFormulaRandomDate, '<' + Format(RandInt(MaxDate - MinDate + 1)) + 'D>');
        exit(CalcDate(DateFormulaRandomDate, CalcDate(DateFormulaMinDate, MinDate)));
    end;


    /* Note!  This is NOT the base functionality in the toolkit, they used a no series for it so it's reproducable */
    procedure GenerateGUID(): Code[10]
    var
        RandomGuid: Guid;
    begin
        RandomGuid := CreateGuid();
        exit(RandomGuid);
    end;

    procedure GetEmptyGuid(): Guid
    var
        EmptyGuid: Guid;
    begin
        exit(EmptyGuid);
    end;

    procedure GenerateRandomRec(var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        i: Integer;
    begin
        for i := 1 to RecRef.FieldCount do begin
            FieldRef := RecRef.FieldIndex(i);
            if FieldRef.Class = FieldClass::Normal then
                case FieldRef.Type of
                    FieldType::Text:
                        FieldRef.Value := GenerateRandomXMLText(FieldRef.Length);
                    FieldType::Date:
                        FieldRef.Value := GenerateRandomDate(Today, CalcDate('<1Y>'));
                    FieldType::Decimal:
                        FieldRef.Value := RandDec(9999999, 2);
                end;
        end;
    end;
    #endregion LibraryUtilityFunctions
}

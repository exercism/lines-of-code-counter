public static class Helper
{
    private static bool IsYelling (string statement)
    {
        return statement.ToUpper() == statement && System.Text.RegularExpressions.Regex.IsMatch(statement, "[a-zA-Z]+");
    }

    private static bool IsQuestion (string statement)
    {
        return statement.Trim().EndsWith("?");
    }
}
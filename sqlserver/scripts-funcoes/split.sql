SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION Split (
	@InputString VARCHAR(8000),
	@Delimiter VARCHAR(50)
)

RETURNS @Items TABLE (
	Item VARCHAR(8000)
)

AS
BEGIN
      IF @Delimiter = ' '
      BEGIN
		SET @Delimiter = ','
        SET @InputString = REPLACE(@InputString, ' ', @Delimiter)
      END

      IF (@Delimiter IS NULL OR @Delimiter = '')
		SET @Delimiter = ','

      DECLARE @Item VARCHAR(8000)
      DECLARE @ItemList VARCHAR(8000)
      DECLARE @DelimIndex INT

      SET @ItemList = @InputString
      SET @DelimIndex = CHARINDEX(@Delimiter, @ItemList, 0)
      WHILE (@DelimIndex != 0)
      BEGIN
		SET @Item = SUBSTRING(@ItemList, 0, @DelimIndex)
        INSERT INTO @Items VALUES (@Item)

        SET @ItemList = SUBSTRING(@ItemList, @DelimIndex+1, LEN(@ItemList)-@DelimIndex)
        SET @DelimIndex = CHARINDEX(@Delimiter, @ItemList, 0)
      END -- End WHILE

      IF @Item IS NOT NULL -- At least one delimiter was encountered in @InputString
      BEGIN
		SET @Item = @ItemList
        INSERT INTO @Items VALUES (@Item)
      END
      -- No delimiters were encountered in @InputString, so just return @InputString
      ELSE
		INSERT INTO @Items VALUES (@InputString)

      RETURN

END -- End Function

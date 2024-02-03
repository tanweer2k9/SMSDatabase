CREATE FUNCTION [dbo].[LargeOrderShippers] ( @FreightParm money )
RETURNS @OrderShipperTab TABLE
   (
    ShipperID     int,
    ShipperName   nvarchar(80),
    OrderID       int,
    ShippedDate   datetime,
    Freight       money
   )
AS
BEGIN
   INSERT @OrderShipperTab
        SELECT S.ShipperID, S.CompanyName,
               O.OrderID, O.ShippedDate, O.Freight
        FROM Shippers AS S INNER JOIN Orders AS O
              ON S.ShipperID = O.ShipVia
        WHERE O.Freight > @FreightParm
   RETURN
END
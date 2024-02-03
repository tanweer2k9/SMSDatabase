CREATE PROC sp_Attendance_Is_Stop_Insertion


@Type nvarchar(50),
@BrId numeric,
@IsStop bit

AS


update AttendanceScheduleSetting set IsStop = @IsStop where AtendanceScheduleType = @Type and AttendanceBrId = @BrId
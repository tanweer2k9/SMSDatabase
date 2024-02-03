CREATE PROC [dbo].[sp_Attendance_Branches_Schedule]

@Type nvarchar(50),
@BrId numeric

AS


select a.*, b.BR_ADM_NAME BranchName from AttendanceScheduleSetting a
join BR_ADMIN b on b.BR_ADM_ID = a.AttendanceBrId
where a.AtendanceScheduleType = @Type and (@BrId = 0 OR a.AttendanceBrId = @BrId)
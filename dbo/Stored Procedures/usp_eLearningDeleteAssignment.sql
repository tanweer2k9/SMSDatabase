CREATE PROC usp_eLearningDeleteAssignment

@AssignmentId numeric,
@UserId numeric


As


update eLearningAssignments set IsDeleted = 1 where Id = @AssignmentId
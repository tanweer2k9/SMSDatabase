CREATE TABLE [dbo].[STAFF_OVERTIME_SALARY] (
    [OVRTM_ID]                          NUMERIC (18) IDENTITY (1, 1) NOT NULL,
    [OVRTM_STAFF_ID]                    NUMERIC (18) NULL,
    [OVRTM_FROM_DATE]                   DATE         NULL,
    [OVRTM_END_DATE]                    DATE         NULL,
    [OVRTM_TOTAL_HOURS]                 FLOAT (53)   NULL,
    [OVRTM_SHORT_HOURS]                 FLOAT (53)   NULL,
    [OVRTM_NET_HOURS]                   FLOAT (53)   NULL,
    [OVRTM_PER_HOUR_SALARY]             FLOAT (53)   NULL,
    [OVRTM_TOTAL_SALARY]                FLOAT (53)   NULL,
    [OVRTM_ADVANCE]                     FLOAT (53)   NULL,
    [OVRTM_PREVIOUS_SHORT_HOURS_AMOUNT] FLOAT (53)   NULL,
    [OVRTM_NET_SALARY]                  FLOAT (53)   NULL,
    [OVRTM_PAID]                        FLOAT (53)   NULL,
    [OVRTM_PAID_DATE]                   DATETIME     NULL,
    CONSTRAINT [PK_STAFF_OVERTIME_SALARY] PRIMARY KEY CLUSTERED ([OVRTM_ID] ASC)
);


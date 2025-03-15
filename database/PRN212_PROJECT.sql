use [master]
GO

create database [PRN212_PROJECT]
GO

use [PRN212_PROJECT]
GO

CREATE TABLE [dbo].[Role](
    [Role_Id] [int] IDENTITY(1,1) NOT NULL,
    [Role_Name] [nvarchar](MAX) NOT NULL,
    CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED ([Role_Id] ASC)
);
GO

-- Create Table: User
CREATE TABLE [dbo].[User](
    [User_Id] [int] IDENTITY(1,1) NOT NULL,
	[User_name] [nvarchar](MAX) NOT NULL,
    [Password] [nvarchar](MAX) NOT NULL,  -- Store hashed password instead of plaintext
    [Role_Id] [int] NOT NULL,
    CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED ([User_Id] ASC),
    CONSTRAINT [FK_User_Role] FOREIGN KEY ([Role_Id]) REFERENCES [dbo].[Role] ([Role_Id])
);
GO

-- Create Table: ExamHistory
CREATE TABLE [dbo].[ExamHistory](
    [ExamHistory_Id] [int] IDENTITY(1,1) NOT NULL,
    [User_Id] [int] NOT NULL,
    [Score] [float] NULL,
    [ExamTime] [datetime] NOT NULL DEFAULT GETDATE(),
    CONSTRAINT [PK_ExamHistory] PRIMARY KEY CLUSTERED ([ExamHistory_Id] ASC),
    CONSTRAINT [FK_ExamHistory_User] FOREIGN KEY ([User_Id]) REFERENCES [dbo].[User] ([User_Id])
);
GO

-- Create Table: Question
CREATE TABLE [dbo].[Question](
    [Question_Id] [int] IDENTITY(1,1) NOT NULL,
    [Question] [nvarchar](MAX) NOT NULL,
    [Answer1] [nvarchar](MAX) NOT NULL,
    [Answer2] [nvarchar](MAX) NOT NULL,
    [Answer3] [nvarchar](MAX) NOT NULL,
    [Answer4] [nvarchar](MAX) NOT NULL,
    [CorrectAnswer] [int] NOT NULL CHECK ([CorrectAnswer] BETWEEN 1 AND 4),
    [ImgQuestion] [nvarchar](MAX) NULL,
    CONSTRAINT [PK_Question] PRIMARY KEY CLUSTERED ([Question_Id] ASC)
);
GO

-- Create Table: ListQuestion
CREATE TABLE [dbo].[ListQuestion](
    [ListQuestion_Id] [int] IDENTITY(1,1) NOT NULL,
    [ExamHistory_Id] [int] NOT NULL,
    [Question_Id] [int] NOT NULL,
    [Your_Answer] [int] NULL,
    CONSTRAINT [PK_ListQuestion] PRIMARY KEY CLUSTERED ([ListQuestion_Id] ASC),
    CONSTRAINT [FK_ListQuestion_ExamHistory] FOREIGN KEY ([ExamHistory_Id]) REFERENCES [dbo].[ExamHistory] ([ExamHistory_Id]),
    CONSTRAINT [FK_ListQuestion_Question] FOREIGN KEY ([Question_Id]) REFERENCES [dbo].[Question] ([Question_Id])
);
GO
CREATE TABLE [dbo].[Certificate](
[Certificate_Id] [int] IDENTITY(1,1) NOT NULL,
 [User_Id] [int] NOT NULL,
  [Issue_Date] [datetime] NOT NULL DEFAULT GETDATE(),
   [Expiration_Date] [datetime] NULL, 
 CONSTRAINT [PK_Certificate] PRIMARY KEY CLUSTERED ([Certificate_Id] ASC),
    CONSTRAINT [FK_Certificate_User] FOREIGN KEY ([User_Id]) REFERENCES [dbo].[User] ([User_Id])
)
GO
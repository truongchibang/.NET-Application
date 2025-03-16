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
CREATE TABLE [dbo].[Course](
	[Course_Id] [int] IDENTITY(1,1) NOT NULL,
	[CourseName] [varchar](100) NOT NULL,
	[Teacher_Id] [int] NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NULL,
	CONSTRAINT [PK_Course] PRIMARY KEY CLUSTERED ([Course_Id] ASC),
    CONSTRAINT [FK_Course_User] FOREIGN KEY ([Teacher_Id]) REFERENCES [dbo].[User] ([User_Id])
)
CREATE TABLE [dbo].[EnrolCourse](
	[Enrol_Id] [int] IDENTITY(1,1) NOT NULL,
	[Student_Id] [int] NOT NULL,
	[Course_Id] [int] NOT NULL,
	CONSTRAINT [PK_EnrolCourse] PRIMARY KEY CLUSTERED ([Enrol_Id] ASC),
    CONSTRAINT [FK_EnrolCourse_User] FOREIGN KEY ([Student_Id]) REFERENCES [dbo].[User] ([User_Id]),
    CONSTRAINT [FK_EnrolCourse_Course] FOREIGN KEY ([Course_Id]) REFERENCES [dbo].[Course] ([Course_Id])
)

INSERT INTO [dbo].[Role] ([Role_Name])
VALUES 
    ('Student'),  -- Học sinh
    ('Teacher'),  -- Giảng viên
    ('Admin');  -- Quản trị viên hệ thống
	-- Thêm người dùng Admin, Teacher, và Student
INSERT INTO [dbo].[User] ([User_name], [Password], [Role_Id])
VALUES 
    ('admin1', '12345', 3),  -- Admin 
    ('teacher1', '12345', 2),  -- Giảng viên 1
    ('teacher2', '12345', 2),  -- Giảng viên 2
    ('student1', '12345', 1),  -- Học sinh 1
    ('student2', '12345', 1);  -- Học sinh 2
-- Thêm các khóa học
INSERT INTO [dbo].[Course] ([CourseName], [Teacher_Id], [StartDate], [EndDate])
VALUES 
    (N'Khóa học lái xe an toàn cơ bản', 2, '2023-10-01', '2023-10-15'),  -- Giảng viên 1 dạy
    (N'Khóa học lái xe an toàn nâng cao', 3, '2023-10-16', '2023-10-30');  -- Giảng viên 2 dạy
-- Thêm đăng ký khóa học
INSERT INTO [dbo].[EnrolCourse] ([Student_Id], [Course_Id])
VALUES 
    (4, 1),  -- Học sinh 1 đăng ký khóa học cơ bản
    (5, 2);  -- Học sinh 2 đăng ký khóa học nâng cao
	-- Thêm các câu hỏi kỹ năng lái xe an toàn
INSERT INTO [dbo].[Question] ([Question], [Answer1], [Answer2], [Answer3], [Answer4], [CorrectAnswer], [ImgQuestion])
VALUES 
   
    (N'Khi gặp biển báo "Cấm rẽ trái", bạn phải làm gì?', 
     N'Rẽ trái', N'Rẽ phải', N'Đi thẳng', N'Dừng lại', 3, NULL),

  
    (N'Khi tham gia giao thông, bạn cần làm gì khi gặp đèn vàng?', 
     N'Tăng tốc độ để vượt qua', N'Dừng lại', N'Tiếp tục đi', N'Bấm còi', 2, NULL),


    (N'Khi vượt xe khác, bạn cần chú ý điều gì?', 
     N'Vượt bên trái', N'Vượt bên phải', N'Vượt ở nơi có vạch kẻ đường', N'Vượt khi có đủ tầm nhìn', 4, NULL),

   
    (N'Khi tham gia giao thông, bạn cần làm gì khi gặp xe ưu tiên?', 
     N'Tiếp tục đi', N'Nhường đường', N'Bấm còi', N'Tăng tốc độ', 2, NULL),

    
    (N'Khi tham gia giao thông, bạn cần làm gì khi gặp người đi bộ qua đường?', 
     N'Tiếp tục đi', N'Nhường đường', N'Bấm còi', N'Tăng tốc độ', 2, NULL),
	
    (N'Những người có mặt tại nơi xảy ra tai nạn giao thông không có trách nhiệm nào sau đây?', 
     N'Bảo vệ hiện trường, giúp đỡ, cứu chữa kịp thời người bị nạn.', 
     N'Báo tin ngay cho cơ quan công an, y tế hoặc Ủy ban nhân dân nơi gần nhất.', 
     N'Dọn dẹp hiện trường và di chuyển phương tiện tai nạn vào lề đường.', 
     N'Cung cấp thông tin xác thực về vụ tai nạn theo yêu cầu của cơ quan có thẩm quyền.', 
     3, NULL),

  
    (N'Trong các phương án dưới đây, phương án nào bảo đảm an toàn nhất khi điều khiển xe đạp điện tham gia giao thông?', 
     N'Vai buông lỏng tự nhiên, lưng giữ thẳng hơi nghiêng về phía trước, chân đặt ở vị trí tự nhiên, mắt nhìn hướng về phía trước, giữ tầm quan sát rộng, bàn tay nắm lái tự nhiên, cổ tay hơi thấp hơn lưng bàn tay, đầu gối luôn khép và để song song với sàn xe.', 
     N'Vai buông lỏng tự nhiên, lưng giữ thẳng, chân đặt ở vị trí tự nhiên, mắt nhìn hướng về phía trước, giữ tầm quan sát rộng nhất, nắm chặt tay lái, cổ tay hơi thấp hơn lưng bàn tay, đầu gối luôn khép và để song song với sàn xe.', 
     N'Vai buông lỏng tự nhiên, lưng giữ thẳng hơi nghiêng về phía trước, chân đặt ở vị trí tự nhiên, mắt nhìn hướng về phía trước, giữ tầm quan sát rộng nhất, nắm tay lái tự nhiên, cổ tay hơi thấp hơn lưng bàn tay, đầu gối mở rộng về hai bên và để song song với sàn xe.', 
     N'Vai co lên, lưng giữ thẳng hơi nghiêng về phía trước, chân đặt ở vị trí tự nhiên, mắt nhìn hướng về phía trước, nắm tay lái tự nhiên, cổ tay hơi thấp hơn lưng bàn tay, đầu gối luôn khép và để song song với sàn xe.', 
     1, NULL),


    (N'Khi điều khiển xe gắn máy trong điều kiện trời mưa, em cần phải điều khiển phương tiện như thế nào để bảo đảm an toàn?', 
     N'Chú ý quan sát, đi với tốc độ bình thường, ổn định, giữ khoảng cách lớn hơn với các xe khác.', 
     N'Chú ý quan sát, đi chậm, sử dụng phanh thường xuyên.', 
     N'Chú ý quan sát, đi tốc độ thấp, sử dụng phanh sớm hơn, giữ khoảng cách lớn hơn so với điều kiện bình thường.', 
     N'Chú ý quan sát, khi vào đoạn đường cong, đường có khúc cua phải phanh sớm, giữ khoảng cách an toàn.', 
     3, NULL),

    
    (N'Khi gặp đoàn xe, đoàn người có tổ chức đi theo hàng ngũ, người điều khiển phương tiện phải đi như thế nào?', 
     N'Bấm còi, rú ga để đi ngang qua.', 
     N'Không đi cắt ngang qua đoàn xe, đoàn người.', 
     N'Báo hiệu và từ từ đi ngang qua.', 
     N'Dừng lại, quan sát khi bảo đảm an toàn thì nhanh chóng vượt qua.', 
     2, NULL),


    (N'Tại nơi đường bộ giao giao nhau cùng mức với đường sắt chỉ có đèn tín hiệu hoặc chuông báo hiệu, khi đèn tín hiệu màu đỏ đã bật sáng hoặc có tiếng chuông báo hiệu, người tham gia giao thông phải dừng lại và giữ khoảng cách tối thiểu bao nhiêu mét tính từ ray gần nhất?', 
     N'3 mét.', 
     N'4 mét.', 
     N'5 mét.', 
     N'6 mét.', 
     3, NULL),

    
    (N'Lựa chọn phương án điền từ vào chỗ trống của đoạn thông tin quy định về trách nhiệm của người tham gia giao thông: Người tham gia giao thông phải có ý thức (1)….., nghiêm chỉnh chấp hành (2)…. giao thông, giữ gìn (3)…. cho mình và người khác. (4) …. và người điều khiển phương tiện phải chịu trách nhiệm trước pháp luật về việc bảo đảm an toàn của phương tiện tham gia giao thông đường bộ.', 
     N'(1) Tự giác – (2) quy tắc – (3) an toàn – (4) Chủ phương tiện', 
     N'(1) Quy tắc – (2) an toàn – (3) chủ phương tiện – (4) Tự giác', 
     N'(1) Chủ phương tiện – (2) tự giác – (3) an toàn – (4) Quy tắc', 
     N'(1) An toàn – (2) chủ phương tiện – (3) quy tắc – (4) Tự giác.', 
     1, NULL),


    (N'Người điều khiển xe mô tô, xe gắn máy (kể cả xe máy điện), các loại tương tự xe mô tô và các loại xe tương tự xe gắn máy bị phạt tiền từ 6.000.000 đồng đến 8.000.000 đồng đối với hành vi nào dưới đây?', 
     N'Điều khiển xe lạng lách hoặc đánh võng trên đường bộ trong, ngoài đô thị.', 
     N'Điều khiển xe chạy quá tốc độ 20 km/h.', 
     N'Hành vi điều khiển xe lạng lách hoặc đánh võng trên đường bộ trong, ngoài đô thị mà gây tai nạn giao thông.', 
     N'Sử dụng chân chống hoặc vật khác quệt xuống đường khi điều khiển xe trên đường.', 
     1, NULL),

    
    (N'Nhân dịp vừa sinh nhật tròn 16 tuổi, Nam mượn xe mô tô của anh trai để chở bạn lên thị trấn chơi, cả hai đều đội mũ bảo hiểm đảm bảo tiêu chuẩn chất lượng và có cài quai đúng quy cách. Theo em, trong trường hợp trên, ai đã vi phạm quy định pháp luật về bảo đảm trật tự, an toàn giao thông?', 
     N'Nam.', 
     N'Nam và anh trai của Nam.', 
     N'Nam và bạn của Nam.', 
     N'Cả ba người.', 
     2, NULL),

    
    (N'Biển báo nào dưới đây báo hiệu sắp giao với đường ưu tiên?', 
     N'Biển 1.', 
     N'Biển 2.', 
     N'Biển 3.',
     N'Biển 4.', 
     2, 'https://cdn.thuvienphapluat.vn/uploads/phapluat/2022-2/NHPT/hinh-thpt-1.jpg'),

  
    (N'Trong hình dưới đây, thứ tự các xe đi như nào là đúng quy tắc giao thông?', 
     N'Xe công an, xe con, xe tải, xe khách.', 
     N'Xe công an, xe khách, xe con, xe tải.', 
     N'Xe công an, xe tải, xe khách, xe con.', 
     N'Xe con, xe công an, xe tải, xe khách.', 
     1, 'https://cdn.thuvienphapluat.vn/uploads/phapluat/2022-2/NHPT/hinh-thpt-2.jpg'),
	
    (N'Biển báo nào dưới đây báo hiệu đường dành cho người đi bộ?', 
     N'Biển 1', 
     N'Biển 2', 
     N'Biển 3', 
     N'Không có biển nào', 
     3,'https://f.hoatieu.vn/data/image/2022/12/25/bien-bao-nao-duoi-day-chi-duong-danh-cho-nguoi-di-bo.jpg'),
   
    (N'Khi tham gia giao thông, người điều khiển xe máy phải đội mũ bảo hiểm khi nào?', 
     N'Chỉ khi đi trên đường cao tốc.', 
     N'Chỉ khi đi trong đô thị.', 
     N'Khi tham gia giao thông trên tất cả các tuyến đường.', 
     N'Chỉ khi trời mưa.', 
     3, NULL),

    
    (N'Khi tham gia giao thông, người điều khiển xe máy phải mang theo những giấy tờ gì?', 
     N'Giấy phép lái xe, đăng ký xe, bảo hiểm xe.', 
     N'Chỉ cần giấy phép lái xe.', 
     N'Chỉ cần đăng ký xe.', 
     N'Không cần mang theo giấy tờ gì.', 
     1, NULL),

  
    (N'Khi điều khiển xe máy, người lái xe phải làm gì khi gặp đèn vàng?', 
     N'Tăng tốc độ để vượt qua.', 
     N'Dừng lại trước vạch dừng.', 
     N'Tiếp tục đi bình thường.', 
     N'Bấm còi và đi tiếp.', 
     2, NULL),

    
    (N'Biển báo nào dưới đây báo hiệu đường ưu tiên?', 
     N'Biển 1', 
     N'Biển 2', 
     N'Biển 3', 
     N'Không có biển nào', 
     2, 'https://s.tracnghiem.net/images/fckeditor/upload/2020/20200910/images/2020-09-10_093010.jpg'),

  
    (N'Khi điều khiển xe máy, người lái xe phải làm gì khi gặp xe ưu tiên?', 
     N'Tiếp tục đi bình thường.', 
     N'Nhường đường cho xe ưu tiên.', 
     N'Bấm còi để yêu cầu xe ưu tiên nhường đường.', 
     N'Tăng tốc độ để vượt qua.', 
     2, NULL),

   
    (N'Biển báo nào dưới đây báo hiệu đường cấm đi ngược chiều?', 
     N'Biển 1', 
     N'Biển 2', 
     N'Biển 3', 
     N'Không có biển nào', 
     2, 'https://cdn-i.vtcnews.vn/resize/th/upload/2023/09/18/bien-nao-cam-di-nguoc-chieu-1-20591031.jpg'),

    (N'Khi điều khiển xe máy, người lái xe phải làm gì khi gặp người đi bộ qua đường?', 
     N'Tiếp tục đi bình thường.', 
     N'Nhường đường cho người đi bộ.', 
     N'Bấm còi để yêu cầu người đi bộ nhường đường.', 
     N'Tăng tốc độ để vượt qua.', 
     2, NULL);
-- Thêm dữ liệu vào bảng ExamHistory
INSERT INTO [dbo].[ExamHistory] ([User_Id], [Score], [ExamTime])
VALUES 
    (4, 8.5, '2024-03-15 10:00:00'),  -- Học sinh 1 thi với điểm 8.5
    (5, 9.0, '2024-03-19 14:00:00');  -- Học sinh 2 thi với điểm 9.0

-- Thêm dữ liệu vào bảng ListQuestion
-- Học sinh 1 (ExamHistory_Id = 1) trả lời 10 câu hỏi
INSERT INTO [dbo].[ListQuestion] ([ExamHistory_Id], [Question_Id], [Your_Answer])
VALUES 
    (1, 1, 3),  -- Câu hỏi 1
    (1, 2, 2),  -- Câu hỏi 2
    (1, 3, 4),  -- Câu hỏi 3
    (1, 4, 2),  -- Câu hỏi 4
    (1, 5, 2),  -- Câu hỏi 5
    (1, 6, 3),  -- Câu hỏi 6
    (1, 7, 1),  -- Câu hỏi 7
    (1, 8, 2),  -- Câu hỏi 8
    (1, 9, 2),  -- Câu hỏi 9
    (1, 10, 1); -- Câu hỏi 10

-- Học sinh 2 (ExamHistory_Id = 2) trả lời 10 câu hỏi
INSERT INTO [dbo].[ListQuestion] ([ExamHistory_Id], [Question_Id], [Your_Answer])
VALUES 
    (2, 1, 3),  -- Câu hỏi 1
    (2, 2, 2),  -- Câu hỏi 2
    (2, 3, 4),  -- Câu hỏi 3
    (2, 4, 2),  -- Câu hỏi 4
    (2, 5, 2),  -- Câu hỏi 5
    (2, 6, 3),  -- Câu hỏi 6
    (2, 7, 1),  -- Câu hỏi 7
    (2, 8, 2),  -- Câu hỏi 8
    (2, 9, 2),  -- Câu hỏi 9
    (2, 10, 1); -- Câu hỏi 10

-- Thêm dữ liệu vào bảng Certificate
INSERT INTO [dbo].[Certificate] ([User_Id], [Issue_Date], [Expiration_Date])
VALUES 
    (4, '2024-03-15 17:00:00', '2026-03-15 17:00:00'),  -- Học sinh 1 nhận chứng chỉ
    (5, '2024-03-20 10:00:00', '2026-03-20 10:00:00');  -- Học sinh 2 nhận chứng chỉ
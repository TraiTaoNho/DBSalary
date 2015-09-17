create database QLNVLuong
use QLNVLuong

create table [Login]
(
	id int primary key IDENTITY(1,1),
	username varchar(20),
	[password] varchar(20)
)
insert into [Login] values ('admin','admin');

--quản lý đơn vị
create table Unit
(
	Id int primary key IDENTITY(1,1), --mã
	Name nvarchar(255), --tên đơn vị
	[Address] nvarchar(500), --địa chỉ
	Phone varchar(13), -- số điện thoại
	YearEstablish int, --năm thành lập
	[Function] nvarchar(255) -- chức năng nhiệm vụ
)
--quản lý nhiệm vụ và chức vụ
create table Ngach --Ngạch
(
	Code nvarchar(10) primary key, --mã ngạch
	Name nvarchar(255), -- tên ngạch
	[Description] nvarchar(255), -- mô tả
)
create table Designation --Chức vụ
(
	Id int primary key IDENTITY(1,1), --stt chức vụ
	Name nvarchar(255), -- tên chức vụ
	Coefficient float --Hệ số chức vụ
)
insert into Ngach values(N'01.001',N'Chuyên Viên Cao Cấp',N'Nhân viên làm việc ở các đơn vị chức năng, có trình độ Tiến sĩ trở lên.');
insert into Ngach values(N'01.003',N'Chuyên Viên',N'Nhân viên làm việc ở các đơn vị chức năng, có trình độ Đại học trở lên.');
insert into Ngach values(N'15.110',N'Giảng Viên Chính',N'Nhân viên trực tiếp giảng dạy thuộc các khoa có trình độ Thạc sĩ trở lên.');
insert into Ngach values(N'15.111',N'Giảng Viên',N'Nhân viên trực tiếp giảng dạy thuộc các khoa có trình độ Đại học trở lên.');
insert into Ngach values(N'01.004',N'Cán Sự',N'Nhân viên làm việc hành chánh văn phòng ở các đơn vị chức năng, có trình độ THPT trở lên.');
insert into Ngach values(N'01.004',N'Nhân Viên Kỹ Thuật',N'Nhân viên làm việc kĩ thuật ở các đơn vị. Vd: KTV phòng máy vi tính, KTV thư viện…');
insert into Ngach values(N'01.11',N'Nhân Viên Bảo Vệ',N'Nhân viên bảo vệ thuộc phòng Hành chánh');
--------------------
insert into Designation values(N'Hiệu trưởng',0.8)
insert into Designation values(N'Hiệu phó',0.7);
insert into Designation values(N'Trưởng phòng / Trưởng Khoa / Giám đốc trung tâm',0.5);
insert into Designation values(N'Phó phòng / Phó Khoa / Phó Giám đốc trung tâm',0.4);
insert into Designation values(N'Trưởng bộ môn trực thuộc Khoa',0.4);
insert into Designation values(N'Phó bộ môn trực thuộc Khoa',0.3);
--quản lý nhân viên
create table Staff
(
	IdentityNumber int primary key, --chứng minh nhân dân
	IdUnit int foreign key references Unit(id),--mã đơn vị
	Name nvarchar(50),--tên
	Gender nvarchar(5),--giới tính
	DateOfBirth date,--ngày sinh
	Ethnic nvarchar(20),--dân tộc
	[Address] nvarchar(500), --địa chỉ
	Avatar Image, --có thể dùng chuổi để xác định hình
	StartDay date, --ngày làm việc đầu tiên
	RetireDay date,--ngày về hưu
	QuitDay date--ngày từ chức
)
create table Bussiness --quản lý quá trình làm việc của nhân viên **1 ng có thể có nhìu chức vụ
(
	Id int primary key IDENTITY(1,1),
	IdentityNumber int foreign key references Staff(IdentityNumber), --cmnd
	Code nvarchar(10) foreign key references Ngach(Code),--mã ngạch
	IdDesignation int foreign key references Designation(Id),--mã chức vụ
	StartDay date, -- ngày nhận chức
	StartQuit date -- ngày từ chức
)
--quản lý trình độ chuyên môn
create table Specialism --chuyên môn (CNTT,tiếng anh, lịch sử, quản lý,...)
(
	Id int primary key IDENTITY(1,1), --mã
	Name nvarchar(100), -- tên chuyên môn
	[Description] nvarchar(100) --mô tả
)
create table [Certificate] --chứng chỉ (IELTS, TOIEC, PTS, ...)
(
	Id int primary key IDENTITY(1,1), --mã chứng chỉ
	Name nvarchar(100), --tên chứng chỉ
	[Description] nvarchar(100)--mô tả
)
create table Qualification --trình độ chuyên môn
(
	Id int primary key IDENTITY(1,1),
	IdentityNumber int foreign key references Staff(IdentityNumber),
	IdSpecialism int foreign key references Specialism(Id),
	IdCertificate int foreign key references [Certificate](Id),
	Ranking nvarchar(10), -- xếp loại
	IssuedBy nvarchar(200), --nơi cấp
	NgayCap date
)
--quản lý hệ số lương và phụ cấp
create table Salary --lương
(
	Code nvarchar(10) primary key foreign key references Ngach(Code),--mã ngạch
	Duration int, --niên hạn tăng lương
	Level1 float, --hệ số bậc
	level2 float,
	Level3 float,
	level4 float,
	Level5 float,
	level6 float,
	Level7 float,
	level8 float
)
create table Subsidize --phụ cấp
(
	Code nvarchar(10) primary key foreign key references Ngach(Code),
	Level1 float,
	level2 float,
	Level3 float,
	level4 float,
	Level5 float,
	level6 float,
	Level7 float,
	level8 float
)

create table SalaryPerMonth
(
	Stt int primary key IDENTITY(1,1),
	IdentityNumber int foreign key references Staff(IdentityNumber),
	[Month] nvarchar(10),--lập lương cho tháng nào (ex: 06/2015)
	Coefficient float, --HêSố = hệ số bậc + hệ số chức vụ
	BasicSalary int, --LươngCơBản (720k theo 6/2010 có thể điều chỉnh được)
	Subsidize int, --PhụCấp = PhụCấp vượt khung + phụ cấp trình độ chuyên môn (nếu thỏa điều kiện đang áp dụng).
	SumSalary int, --Lương = HệSố * LươngCơBản + PhụCấp
	RealSalary int, --LươngThựcLãnh = Lương – (5% bảo hiểm xã hội + 1% bảo hiểm y tế + 1% bảo hiểm thất nghiệp)
						--[Hệ thống chưa quản lý thuế thu nhập cá nhân]
	NgayLap datetime --ngày lập hóa đơn (ko bjk tiếng anh)

)
go
create procedure InsertStaff
(
	@IdentityNumber int,
	@IdUnit int,
	@Code nvarchar(10),
	@Name nvarchar(50),
	@Gender nvarchar(5),
	@DateOfBirth date,
	@Ethnic nvarchar(20),
	@Address nvarchar(200),
	@Avatar image,
	@StartDay date,
	@RetireDay date,
	@QuitDay date
)
As 
	begin
		if exists(select * from Staff where IdentityNumber=@IdentityNumber)
			RAISERROR ('Đã có nhân viên này trong cơ sở dữ liệu',12,2,2);
			else
				begin
					insert into Staff
					values(@IdentityNumber,@IdUnit,@Code,@Name,@Gender,@DateOfBirth,@Ethnic,@Address,@Avatar,@StartDay,@RetireDay,@QuitDay)
	end
end
go
create procedure UpdateSalary
(
	@Code nvarchar(10),
	@Duration int,
	@Level1 float,
	@level2 float,
	@Level3 float,
	@level4 float,
	@Level5 float,
	@level6 float,
	@Level7 float,
	@level8 float
)
As 
	begin
		if @Level1<=@level2 and @level2<=@Level3 and @Level3<=@level4 and @Level4<=@level5 and @level5<=@Level6 and @Level6<=@level7 and @Level7<=@level8 and @Duration>0
			begin
					update Salary set 
					Duration = @Duration,
					Level1 = @Level1,
					Level2 = @Level2,
					level3 = @Level3,
					Level4 = @Level4,
					Level5 = @Level5,
					Level6 = @Level6,
					Level7 = @Level7,
					Level8 = @Level8
					where Code=@Code
			end
		else
			RAISERROR ('Dữ liệu lương không hợp lý',12,2,2);
				
	end

go
create procedure UpdateSubsidize
(
	@Code nvarchar(10),
	@Level1 float,
	@level2 float,
	@Level3 float,
	@level4 float,
	@Level5 float,
	@level6 float,
	@Level7 float,
	@level8 float
)
As 
	begin
		if @Level1<=@level2 and @level2<=@Level3 and @Level3<=@level4 and @Level4<=@level5 and @level5<=@Level6 and @Level6<=@level7 and @Level7<=@level8
			begin
					update Salary set 
					Level1 = @Level1,
					Level2 = @Level2,
					level3 = @Level3,
					Level4 = @Level4,
					Level5 = @Level5,
					Level6 = @Level6,
					Level7 = @Level7,
					Level8 = @Level8
					where Code=@Code
				end
		else
			RAISERROR ('Dữ liệu lương không hợp lý',12,2,2);
				
	end
go
create trigger Insert_into_SalaryAndSubsidize on Ngach
for insert
as
	declare @Code varchar(10);

	select @Code=i.Code from inserted i;

	insert into Salary 
	values (@Code,1,0,0,0,0,0,0,0,0);
	insert into Subsidize 
	values (@Code,0,0,0,0,0,0,0,0);
	print 'after insert';
go
create trigger Delete_on_SalaryandSubsidize on Ngach instead of delete
as
	declare @Code varchar(10);
	select @Code=d.Code from deleted d;
	
	delete from Salary where Code = @Code;
	delete from Subsidize where Code = @Code;
	print 'after delete ';
go
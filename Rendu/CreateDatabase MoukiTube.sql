/*
	Auteur : Paul-Loup Germain & Mathias Bourqui
	Date : 12/01/2022
	Projet : Cr�ation du fichier permettant de cr�er la base de donn�e de Moukitube
*/

USE master;
GO
	DROP DATABASE IF exists Moukitube
	CREATE DATABASE Moukitube
		ON
		(NAME = Moukitube_data ,
		FILENAME = 'C:\Data_Base\Moukitube.mdf',	/* Choisir son emplacement de fichier */
		SIZE = 20MB,
		MAXSIZE = 50MB,
		FILEGROWTH = 1MB)
	LOG ON 
		(NAME = Moukitube_log,
		FILENAME = 'C:\Data_Base\Moukitube.ldf',	/* Choisir son emplacement de fichier */
		SIZE = 10MB,
		MAXSIZE = 20MB,
		FILEGROWTH = 1MB);

GO
	DROP TABLE IF exists Moukitube.dbo.subscriptions
	Create table Moukitube.dbo.subscriptions(
		id INT NOT NULL,
		CONSTRAINT PK_subscriptions_id PRIMARY KEY CLUSTERED (id),
		types VARCHAR(100) NOT NULL,
		CONSTRAINT Uniqueplace_subscriptions UNIQUE (types)
	)

GO
	DROP TABLE IF exists Moukitube.dbo.monetization
	Create table Moukitube.dbo.monetization(
		id INT NOT NULL,
		CONSTRAINT PK_monetization_id PRIMARY KEY CLUSTERED (id),
		date DATE NOT NULL,
		amount FLOAT NOT NULL,
		CONSTRAINT Uniqueplace_monetization UNIQUE (date, amount)
	)

GO
	DROP TABLE IF exists Moukitube.dbo.channel
	Create table Moukitube.dbo.channel(
		id INT NOT NULL,
		CONSTRAINT PK_channel_id PRIMARY KEY CLUSTERED (id),
		name VARCHAR(100) NOT NULL,
		date DATE NOT NULL,
		follower INT NOT NULL,
		monetization_id INT FOREIGN KEY REFERENCES Moukitube.dbo.monetization(id),
		CONSTRAINT Uniqueplace_channel UNIQUE (name, date, follower)
	)

GO
	DROP TABLE IF exists Moukitube.dbo.storie
	Create table Moukitube.dbo.storie(
		id INT NOT NULL,
		CONSTRAINT PK_storie_id PRIMARY KEY CLUSTERED (id),
		channelname VARCHAR(100) NOT NULL,
		date DATE NULL,
		time TIME NULL,
		channel_id INT FOREIGN KEY REFERENCES Moukitube.dbo.channel(id),
		CONSTRAINT Uniqueplace_storie UNIQUE (channelname, date, time)
	)

GO
	DROP TABLE IF exists Moukitube.dbo.channel_share_storie
	Create table Moukitube.dbo.channel_share_storie(
		id INT NOT NULL,
		CONSTRAINT PK_channel_share_storie_id PRIMARY KEY CLUSTERED (id),
		channel_id INT FOREIGN KEY REFERENCES Moukitube.dbo.channel(id),
		storie_id INT FOREIGN KEY REFERENCES Moukitube.dbo.storie(id),
	)

GO
	DROP TABLE IF exists Moukitube.dbo.users
	Create table Moukitube.dbo.users(
		id INT NOT NULL,
		CONSTRAINT PK_users_id PRIMARY KEY CLUSTERED (id),
		name VARCHAR(100) NOT NULL,
		firstname VARCHAR(100) NOT NULL,
		email VARCHAR(100) NOT NULL,
		password VARCHAR(48) NOT NULL,	
		date DATE NULL,
		channel_id INT FOREIGN KEY REFERENCES Moukitube.dbo.channel(id),
		subscriptions_id INT FOREIGN KEY REFERENCES Moukitube.dbo.subscriptions(id),
		CONSTRAINT Uniqueplace_users UNIQUE (name, firstname, email, password)
	)

GO
	DROP TABLE IF exists Moukitube.dbo.types
	Create table Moukitube.dbo.types(
		id INT NOT NULL,
		CONSTRAINT PK_types_id PRIMARY KEY CLUSTERED (id),
		name VARCHAR (30) NOT NULL,
		CONSTRAINT Uniqueplace_types UNIQUE (name)
	)

GO
	DROP TABLE IF exists Moukitube.dbo.videos
	Create table Moukitube.dbo.videos(
		id INT NOT NULL,
		CONSTRAINT PK_videos_id PRIMARY KEY CLUSTERED (id),
		title VARCHAR(100) NOT NULL,
		channelname VARCHAR(100) NOT NULL,
		date DATE NOT NULL,
		viewes DECIMAL NOT NULL,										
		types_id INT FOREIGN KEY REFERENCES Moukitube.dbo.types(id)
		CONSTRAINT Uniqueplace_videos UNIQUE (title, channelname)
	)

GO
	DROP TABLE IF exists Moukitube.dbo.comments
	Create table Moukitube.dbo.comments(
		id INT NOT NULL,
		CONSTRAINT PK_comments_id PRIMARY KEY CLUSTERED (id),
		channelname VARCHAR(100) NOT NULL,
		description VARCHAR(100) NOT NULL,
		videos_id INT FOREIGN KEY REFERENCES Moukitube.dbo.videos(id)
		CONSTRAINT Uniqueplace_comments UNIQUE (channelname)
	)

GO
	DROP TABLE IF exists Moukitube.dbo.sponsor
	Create table Moukitube.dbo.sponsor(
		id INT NOT NULL,
		CONSTRAINT PK_sponsor_id PRIMARY KEY CLUSTERED (id),
		name VARCHAR (100) NOT NULL,
		CONSTRAINT Uniquesponsorr UNIQUE (Name)
	)

GO
	DROP TABLE IF exists Moukitube.dbo.videos_sponsorised_sponsors
	Create table Moukitube.dbo.videos_sponsorised_sponsors(
		id INT NOT NULL,
		CONSTRAINT PK_videos_sponsorised_sponsors_id PRIMARY KEY CLUSTERED (id),
		price FLOAT NULL,
		videos_id INT FOREIGN KEY REFERENCES Moukitube.dbo.videos(id),
		sponsor_id INT FOREIGN KEY REFERENCES Moukitube.dbo.sponsor(id),
		CONSTRAINT Uniquevideos_sponsorised_sponsors UNIQUE (price)
	)

GO
	DROP TABLE IF exists Moukitube.dbo.videos_like_users
	Create table Moukitube.dbo.videos_like_users(
		id INT NOT NULL,
		CONSTRAINT PK_videos_like_users_id PRIMARY KEY CLUSTERED (id),
		types VARCHAR(100) NULL,
		videos_id INT FOREIGN KEY REFERENCES Moukitube.dbo.videos(id),
		users_id INT FOREIGN KEY REFERENCES Moukitube.dbo.users(id),
	)

GO
	DROP TABLE IF exists Moukitube.dbo.videos_share_users
	Create table Moukitube.dbo.videos_share_users(
		id INT NOT NULL,
		CONSTRAINT PK_videos_share_users_id PRIMARY KEY CLUSTERED (id),
		videos_id INT FOREIGN KEY REFERENCES Moukitube.dbo.videos(id),
		users_id INT FOREIGN KEY REFERENCES Moukitube.dbo.users(id),
	)

GO
	DROP TABLE IF exists Moukitube.dbo.playlists
	Create table Moukitube.dbo.playlists(
		id INT NOT NULL,
		CONSTRAINT PK_playlists_id PRIMARY KEY CLUSTERED (id),
		name VARCHAR (50) NOT NULL,
		channel VARCHAR(100) NOT NULL,
		types_id INT FOREIGN KEY REFERENCES Moukitube.dbo.types(id),
		users_id INT FOREIGN KEY REFERENCES Moukitube.dbo.users(id),
	)

GO
	DROP TABLE IF exists Moukitube.dbo.playlists_read_users
	Create table Moukitube.dbo.playlists_read_users(
		id INT NOT NULL,
		CONSTRAINT PK_playlists_read_users_id PRIMARY KEY CLUSTERED (id),
		playlists_id INT FOREIGN KEY REFERENCES Moukitube.dbo.playlists(id),
		users_id INT FOREIGN KEY REFERENCES Moukitube.dbo.users(id),
	)

GO
	DROP TABLE IF exists Moukitube.dbo.storie_like_channel
	Create table Moukitube.dbo.storie_like_channel(
		id INT NOT NULL,
		CONSTRAINT PK_stories_like_channel_id PRIMARY KEY CLUSTERED (id),
		types VARCHAR (100) NOT NULL,
		storie_id INT FOREIGN KEY REFERENCES Moukitube.dbo.storie(id),
		channel_id INT FOREIGN KEY REFERENCES Moukitube.dbo.channel(id),
	)
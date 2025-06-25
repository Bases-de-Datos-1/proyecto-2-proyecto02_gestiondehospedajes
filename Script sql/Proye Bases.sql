CREATE DATABASE TurismoLimon;
GO

USE TurismoLimon;
GO

-- Tabla principal de hoteles
CREATE TABLE ServicioHospedaje (
    idHotel INT PRIMARY KEY IDENTITY(1,1),
    NombreHotel VARCHAR(100) UNIQUE NOT NULL,
    CedulaJuridica VARCHAR(20) UNIQUE NOT NULL,
    Tipo VARCHAR(30) NOT NULL,
    Provincia VARCHAR(50) NOT NULL,
    Canton VARCHAR(50) NOT NULL,
    Distrito VARCHAR(50) NOT NULL,
    Barrio VARCHAR(100) NOT NULL,
    SennasExactas VARCHAR(250) NOT NULL,
    ReferenciaGPS VARCHAR(100) NOT NULL,
    CorreoElectronico VARCHAR(100) NOT NULL CHECK (CorreoElectronico LIKE '%@%.%'),
    UrlHotel VARCHAR(100) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);

CREATE TABLE Telefonos (
    idTelefono INT PRIMARY KEY IDENTITY(1,1),
    idHotel INT FOREIGN KEY REFERENCES ServicioHospedaje(idHotel),
    Numero VARCHAR(20) NOT NULL
);

CREATE TABLE RedesSociales (
    idRedSocial INT PRIMARY KEY IDENTITY(1,1),
    idHotel INT FOREIGN KEY REFERENCES ServicioHospedaje(idHotel),
    Nombre VARCHAR(30) NOT NULL,
    URLCuenta VARCHAR(250) NOT NULL
);

CREATE TABLE Servicio (
    idServicioHotel INT PRIMARY KEY IDENTITY(1,1),
    idHotel INT FOREIGN KEY REFERENCES ServicioHospedaje(idHotel),
    DescripcionServicio VARCHAR(200) NOT NULL
);

CREATE TABLE TipoHabitacion (
    idTipoHabitacion INT PRIMARY KEY IDENTITY(1,1),
    idHotel INT FOREIGN KEY REFERENCES ServicioHospedaje(idHotel),
    Nombre VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(200) NOT NULL,
    TipoCama VARCHAR(50) NOT NULL,
    Precio DECIMAL(10, 2) CHECK (Precio >= 0) NOT NULL
);

CREATE TABLE FotosHabitacion (
    idFoto INT PRIMARY KEY IDENTITY(1,1),
    idTipoHabitacion INT FOREIGN KEY REFERENCES TipoHabitacion(idTipoHabitacion),
    URLFoto VARCHAR(255) NOT NULL
);

CREATE TABLE Comodidades (
    idComodidadHabitacion INT PRIMARY KEY IDENTITY(1,1),
    idTipoHabitacion INT FOREIGN KEY REFERENCES TipoHabitacion(idTipoHabitacion),
    Descripcion NVARCHAR(150) NOT NULL
);

CREATE TABLE DatosHabitaciones (
    idHabitacion INT PRIMARY KEY IDENTITY(1,1),
    idHotel INT FOREIGN KEY REFERENCES ServicioHospedaje(idHotel),
    idTipoHabitacion INT FOREIGN KEY REFERENCES TipoHabitacion(idTipoHabitacion),
    Numero VARCHAR(20) NOT NULL
);

CREATE TABLE Cliente (
    idCliente INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(50) NOT NULL,
    PrimerApellido VARCHAR(50) NOT NULL,
    SegundoApellido VARCHAR(50) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    TipoIdentificacion VARCHAR(30) NOT NULL,
    Cedula VARCHAR(30) UNIQUE NOT NULL,
    PaisResidencia VARCHAR(50) NOT NULL,
    Provincia VARCHAR(50) NOT NULL,
    Canton VARCHAR(50) NOT NULL,
    Distrito VARCHAR(50) NOT NULL,
    Telefono1 VARCHAR(20) NOT NULL,
    Telefono2 VARCHAR(20) NOT NULL,
    Telefono3 VARCHAR(20) NOT NULL,
    CorreoElectronico VARCHAR(100) NOT NULL CHECK (CorreoElectronico LIKE '%@%.%'),
    Activo BIT NOT NULL DEFAULT 1
);

CREATE TABLE Reservaciones (
    idReserva INT PRIMARY KEY IDENTITY(1,1),
    idCliente INT FOREIGN KEY REFERENCES Cliente(idCliente),
    idHabitacion INT FOREIGN KEY REFERENCES DatosHabitaciones(idHabitacion),
    FechaIngreso DATETIME NOT NULL,
    FechaSalida DATETIME NOT NULL,
    CantidadPersonas INT CHECK (CantidadPersonas > 0) NOT NULL,
    Vehiculo VARCHAR(50) NOT NULL
);

CREATE TABLE Facturas (
    idFactura INT PRIMARY KEY IDENTITY(1,1),
    idReserva INT FOREIGN KEY REFERENCES Reservaciones(idReserva),
    FechaFacturacion DATETIME NOT NULL,
    TotalPagar DECIMAL(10, 2) NOT NULL,
    MetodoPago VARCHAR(50) NOT NULL
);

CREATE TABLE EmpresasRecreaciones (
    idEmpresaRecreaciones INT PRIMARY KEY IDENTITY(1,1),
    NombreEmpresa VARCHAR(100) NOT NULL,
    CedulaJuridica VARCHAR(20) UNIQUE NOT NULL,
    CorreoElectronico VARCHAR(100) NOT NULL CHECK (CorreoElectronico LIKE '%@%.%'),
    Telefono VARCHAR(20) NOT NULL,
    NombrePersonaContacto VARCHAR(100) NOT NULL,
    Provincia VARCHAR(50) NOT NULL,
    Canton VARCHAR(50) NOT NULL,
    Distrito VARCHAR(50) NOT NULL,
    SennasExactas VARCHAR(250) NOT NULL
);

CREATE TABLE ActividadRecreaciones (
    idActividad INT PRIMARY KEY IDENTITY(1,1),
    idHotel INT FOREIGN KEY REFERENCES ServicioHospedaje(idHotel),
    idEmpresaRecreaciones INT FOREIGN KEY REFERENCES EmpresasRecreaciones(idEmpresaRecreaciones),
    Descripcion VARCHAR(250) NOT NULL,
    Precio DECIMAL(10, 2) NOT NULL CHECK (Precio >= 0) 
);

------------------------------------------------------

-- Agregar un nuevo hotel
CREATE PROCEDURE AgregarHotel
    @NombreHotel VARCHAR(100),
    @CedulaJuridica VARCHAR(20),
    @Tipo VARCHAR(30),
    @Provincia VARCHAR(50),
    @Canton VARCHAR(50),
    @Distrito VARCHAR(50),
    @Barrio VARCHAR(100),
    @SennasExactas VARCHAR(250),
    @ReferenciaGPS VARCHAR(100),
    @CorreoElectronico VARCHAR(100),
    @UrlHotel VARCHAR(100),
	@Activo BIT 
AS
BEGIN
    INSERT INTO ServicioHospedaje (NombreHotel, CedulaJuridica, Tipo, Provincia, Canton, Distrito, Barrio, SennasExactas, ReferenciaGPS, CorreoElectronico, UrlHotel, Activo)
    VALUES (@NombreHotel, @CedulaJuridica, @Tipo, @Provincia, @Canton, @Distrito, @Barrio, @SennasExactas, @ReferenciaGPS, @CorreoElectronico, @UrlHotel, @Activo);
END;

-- Parametros

EXEC AgregarHotel 
    @NombreHotel = 'Hotel Caribe',
    @CedulaJuridica = '8765432100',
    @Tipo = 'Hotel 4 Estrellas',
    @Provincia = 'Puntarenas',
    @Canton = 'Canton de Puntarenas',
    @Distrito = 'Distrito Central',
    @Barrio = 'Barrio del Mar',
    @SennasExactas = 'A 100 metros de la playa, junto al muelle',
    @ReferenciaGPS = '09.227340, -84.871294',
    @CorreoElectronico = 'info@hotelcaribe.cr',
    @UrlHotel = 'www.hotelcaribe.cr',
	@Activo = 1;

-- Eliminar un hotel
CREATE PROCEDURE EliminarHotel
    @idHotel INT
AS
BEGIN
    -- Validar si existe el hotel
    IF NOT EXISTS (SELECT 1 FROM ServicioHospedaje WHERE idHotel = @idHotel)
    BEGIN
        RAISERROR('No se encontró el hotel especificado.', 16, 1);
        RETURN;
    END

    -- Validacion de la relacion con las facturas
    IF EXISTS (
        SELECT 1
        FROM Facturas f
        JOIN Reservaciones r ON f.idReserva = r.idReserva
        JOIN DatosHabitaciones dh ON r.idHabitacion = dh.idHabitacion
        WHERE dh.idHotel = @idHotel
    )
    BEGIN
        RAISERROR('No se puede eliminar el hotel ya que existen facturas asociadas.', 16, 1);
        RETURN;
    END

    -- Si pasa ambas validaciones, se desactiva
    UPDATE ServicioHospedaje
    SET Activo = 0
    WHERE idHotel = @idHotel;

    PRINT 'El hotel ha sido desactivado';
END



-- Modificar un hotel
CREATE PROCEDURE ModificarHotel
    @idHotel INT,
    @NombreHotel VARCHAR(100),
    @CedulaJuridica VARCHAR(20),
    @Tipo VARCHAR(30),
    @Provincia VARCHAR(50),
    @Canton VARCHAR(50),
    @Distrito VARCHAR(50),
    @Barrio VARCHAR(100),
    @SennasExactas VARCHAR(250),
    @ReferenciaGPS VARCHAR(100),
    @CorreoElectronico VARCHAR(100),
    @UrlHotel VARCHAR(100),
    @Activo BIT
AS
BEGIN
    -- Validacion: existe el hotel
    IF NOT EXISTS (SELECT 1 FROM ServicioHospedaje WHERE idHotel = @idHotel)
    BEGIN
        RAISERROR('No se encontro el hotel especificado.', 16, 1);
        RETURN;
    END

    UPDATE ServicioHospedaje
    SET 
        NombreHotel = @NombreHotel,
        CedulaJuridica = @CedulaJuridica,
        Tipo = @Tipo,
        Provincia = @Provincia,
        Canton = @Canton,
        Distrito = @Distrito,
        Barrio = @Barrio,
        SennasExactas = @SennasExactas,
        ReferenciaGPS = @ReferenciaGPS,
        CorreoElectronico = @CorreoElectronico,
        UrlHotel = @UrlHotel,
        Activo = @Activo
    WHERE idHotel = @idHotel;
END;


-- Parametros

EXEC ModificarHotel
    @idHotel = 4,
    @NombreHotel = 'Hotel del Valle',
    @CedulaJuridica = '3023456789',
    @Tipo = 'Ecolodge',
    @Provincia = 'Alajuela',
    @Canton = 'San Carlos',
    @Distrito = 'La Fortuna',
    @Barrio = 'Calle Cataratas',
    @SennasExactas = 'A 500 metros de la entrada al parque nacional',
    @ReferenciaGPS = '10.4717,-84.6455',
    @CorreoElectronico = 'info@hoteldelvalle.cr',
    @UrlHotel = 'www.hoteldelvalle.cr',
	@Activo = 1;


-- Consultar hotel
CREATE PROCEDURE ConsultarHoteles
    @Provincia VARCHAR(50) = NULL,
    @Canton VARCHAR(50) = NULL,
    @Distrito VARCHAR(50) = NULL,
    @Tipo VARCHAR(30) = NULL
AS
BEGIN
    SELECT * FROM ServicioHospedaje
    WHERE 
        (@Provincia IS NULL OR Provincia = @Provincia) AND
        (@Canton IS NULL OR Canton = @Canton) AND
        (@Distrito IS NULL OR Distrito = @Distrito) AND
        (@Tipo IS NULL OR Tipo = @Tipo);
END;

--Consultas con filtros para los hoteles

EXEC ConsultarHoteles;
EXEC ConsultarHoteles @Provincia = 'Guanacaste';
EXEC ConsultarHoteles @Provincia = 'Guanacaste', @Tipo = 'Boutique';
EXEC ConsultarHoteles 
    @Provincia = 'Puntarenas',
    @Canton = 'Garabito',
    @Distrito = 'Jacó';


select * from ServicioHospedaje

-----------------------------------------------------------------------

--Agregar un telefono
CREATE PROCEDURE AgregarTelefono
    @idHotel INT,
    @Numero VARCHAR(20)
AS
BEGIN
    INSERT INTO Telefonos (idHotel, Numero)
    VALUES (@idHotel, @Numero);
END;

--Parametros
EXEC AgregarTelefono
    @idHotel = 1,
    @Numero = '8888-8888';


--Eliminar un telefono
CREATE PROCEDURE EliminarTelefono
    @idTelefono INT
AS
BEGIN
    DELETE FROM Telefonos
    WHERE idTelefono = @idTelefono;
END;

--Parametros
EXEC EliminarTelefono
    @idTelefono = 3;


--Modificar un telefono
CREATE PROCEDURE ModificarTelefono
    @idTelefono INT,
    @idHotel INT,
    @Numero VARCHAR(20)
AS
BEGIN
    UPDATE Telefonos
    SET idHotel = @idHotel,
        Numero = @Numero
    WHERE idTelefono = @idTelefono;
END;

--Parametros
EXEC ModificarTelefono
    @idTelefono = 2,
    @idHotel = 1,
    @Numero = '2222-2222';


-- Consultar telefonos 
CREATE PROCEDURE ConsultarTelefonos
    @idHotel INT = NULL,
    @Numero VARCHAR(20) = NULL
AS
BEGIN
    SELECT * FROM Telefonos
    WHERE (@idHotel IS NULL OR idHotel = @idHotel)
      AND (@Numero IS NULL OR Numero = @Numero);
END;

--Parametros
EXEC ConsultarTelefonos;
EXEC ConsultarTelefonos @idHotel = 1;
EXEC ConsultarTelefonos @Numero = '8888-1234';

-------------------------------------------------------------------

--Agregar red social
CREATE PROCEDURE AgregarRedSocial
    @idHotel INT,
    @Nombre VARCHAR(30),
    @URLCuenta VARCHAR(250)
AS
BEGIN
    INSERT INTO RedesSociales (idHotel, Nombre, URLCuenta)
    VALUES (@idHotel, @Nombre, @URLCuenta);
END;


--Parametros
EXEC AgregarRedSocial
    @idHotel = 1,
    @Nombre = 'Instagram',
    @URLCuenta = 'https://instagram.com/hotel1';


--Eliminar red social
CREATE PROCEDURE EliminarRedSocial
    @idRedSocial INT
AS
BEGIN
    DELETE FROM RedesSociales
    WHERE idRedSocial = @idRedSocial;
END;


--Parametros
EXEC EliminarRedSocial
    @idRedSocial = 3;


--Modificar red social
CREATE PROCEDURE ModificarRedSocial
    @idRedSocial INT,
    @idHotel INT,
    @Nombre VARCHAR(30),
    @URLCuenta VARCHAR(250)
AS
BEGIN
    UPDATE RedesSociales
    SET idHotel = @idHotel,
        Nombre = @Nombre,
        URLCuenta = @URLCuenta
    WHERE idRedSocial = @idRedSocial;
END;

--Parametros
EXEC ModificarRedSocial
    @idRedSocial = 3,
    @idHotel = 1,
    @Nombre = 'Facebook',
    @URLCuenta = 'https://facebook.com/hotel1';


--Consultar Redes Sociales
CREATE PROCEDURE ConsultarRedesSociales
    @idHotel INT = NULL,
    @Nombre VARCHAR(30) = NULL
AS
BEGIN
    SELECT * FROM RedesSociales
    WHERE (@idHotel IS NULL OR idHotel = @idHotel)
      AND (@Nombre IS NULL OR Nombre = @Nombre);
END;

--Parametros
EXEC ConsultarRedesSociales;
EXEC ConsultarRedesSociales @idHotel = 1;
EXEC ConsultarRedesSociales @Nombre = 'Instagram';

----------------------------------------------------------------------

--Agregar un servicio
CREATE PROCEDURE AgregarServicio
    @idHotel INT,
    @DescripcionServicio VARCHAR(200)
AS
BEGIN
    INSERT INTO Servicio (idHotel, DescripcionServicio)
    VALUES (@idHotel, @DescripcionServicio);
END;

--Parametros
EXEC AgregarServicio
    @idHotel = 1,
    @DescripcionServicio = 'Servicio de transporte al aeropuerto';


--Eliminar un servicio
CREATE PROCEDURE EliminarServicio
    @idServicioHotel INT
AS
BEGIN
    DELETE FROM Servicio
    WHERE idServicioHotel = @idServicioHotel;
END;

--Parametros
EXEC EliminarServicio
    @idServicioHotel = 2;


--Modificar un servicio
CREATE PROCEDURE ModificarServicio
    @idServicioHotel INT,
    @idHotel INT,
    @DescripcionServicio VARCHAR(200)
AS
BEGIN
    UPDATE Servicio
    SET idHotel = @idHotel,
        DescripcionServicio = @DescripcionServicio
    WHERE idServicioHotel = @idServicioHotel;
END;

--Parametros
EXEC ModificarServicio
    @idServicioHotel = 2,
    @idHotel = 1,
    @DescripcionServicio = 'Desayuno buffet incluido';


--Consultar servicios
CREATE PROCEDURE ConsultarServicios
    @idHotel INT = NULL,
    @DescripcionServicio VARCHAR(200) = NULL
AS
BEGIN
    SELECT * FROM Servicio
    WHERE (@idHotel IS NULL OR idHotel = @idHotel)
      AND (@DescripcionServicio IS NULL OR DescripcionServicio LIKE '%' + @DescripcionServicio + '%');
END;

--Parametros
EXEC ConsultarServicios;
EXEC ConsultarServicios @idHotel = 1;
EXEC ConsultarServicios @DescripcionServicio = '%transporte%';

----------------------------------------------------------------------------

--Agregar tipo de habitacion
CREATE PROCEDURE AgregarTipoHabitacion
    @idHotel INT,
    @Nombre VARCHAR(50),
    @Descripcion VARCHAR(200),
    @TipoCama VARCHAR(50),
    @Precio DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO TipoHabitacion (idHotel, Nombre, Descripcion, TipoCama, Precio)
    VALUES (@idHotel, @Nombre, @Descripcion, @TipoCama, @Precio);
END;

--Parametros
EXEC AgregarTipoHabitacion
    @idHotel = 1,
    @Nombre = 'Suite Deluxe',
    @Descripcion = 'Habitación amplia con vista al mar y jacuzzi',
    @TipoCama = 'King',
    @Precio = 250.00;


--Eliminar tipo de habitacion
CREATE PROCEDURE EliminarTipoHabitacion
    @idTipoHabitacion INT
AS
BEGIN
    DELETE FROM TipoHabitacion
    WHERE idTipoHabitacion = @idTipoHabitacion;
END;

--Parametros
EXEC EliminarTipoHabitacion
    @idTipoHabitacion = 3;


--Modificar tipo de habitacion
CREATE PROCEDURE ModificarTipoHabitacion
    @idTipoHabitacion INT,
    @idHotel INT,
    @Nombre VARCHAR(50),
    @Descripcion VARCHAR(200),
    @TipoCama VARCHAR(50),
    @Precio DECIMAL(10, 2)
AS
BEGIN
    UPDATE TipoHabitacion
    SET idHotel = @idHotel,
        Nombre = @Nombre,
        Descripcion = @Descripcion,
        TipoCama = @TipoCama,
        Precio = @Precio
    WHERE idTipoHabitacion = @idTipoHabitacion;
END;

--Parametros
EXEC ModificarTipoHabitacion
    @idTipoHabitacion = 3,
    @idHotel = 1,
    @Nombre = 'Suite Premium',
    @Descripcion = 'Renovada con aire acondicionado y balcón',
    @TipoCama = 'Queen',
    @Precio = 220.00;


--Consultar tipos de habitacion
CREATE PROCEDURE ConsultarTipoHabitacion
    @idHotel INT = NULL,
    @Nombre VARCHAR(50) = NULL,
    @TipoCama VARCHAR(50) = NULL
AS
BEGIN
    SELECT * FROM TipoHabitacion
    WHERE (@idHotel IS NULL OR idHotel = @idHotel)
      AND (@Nombre IS NULL OR Nombre LIKE '%' + @Nombre + '%')
      AND (@TipoCama IS NULL OR TipoCama LIKE '%' + @TipoCama + '%');
END;

--Parametros
EXEC ConsultarTipoHabitacion;
EXEC ConsultarTipoHabitacion @idHotel = 1;
EXEC ConsultarTipoHabitacion @Nombre = 'Suite';

--------------------------------------------------------------------------

--Agregar foto
CREATE PROCEDURE AgregarFotoHabitacion
    @idTipoHabitacion INT,
    @URLFoto VARCHAR(255)
AS
BEGIN
    INSERT INTO FotosHabitacion (idTipoHabitacion, URLFoto)
    VALUES (@idTipoHabitacion, @URLFoto);
END;

--Parametros
EXEC AgregarFotoHabitacion
    @idTipoHabitacion = 2,
    @URLFoto = 'https://ejemplo.com/fotos/suite1.jpg';


--Eliminar foto
CREATE PROCEDURE EliminarFotoHabitacion
    @idFoto INT
AS
BEGIN
    DELETE FROM FotosHabitacion
    WHERE idFoto = @idFoto;
END;

--Parametros
EXEC EliminarFotoHabitacion
    @idFoto = 5;


--Modificar foto
CREATE PROCEDURE ModificarFotoHabitacion
    @idFoto INT,
    @idTipoHabitacion INT,
    @URLFoto VARCHAR(255)
AS
BEGIN
    UPDATE FotosHabitacion
    SET idTipoHabitacion = @idTipoHabitacion,
        URLFoto = @URLFoto
    WHERE idFoto = @idFoto;
END;

--Parametros
EXEC ModificarFotoHabitacion
    @idFoto = 5,
    @idTipoHabitacion = 2,
    @URLFoto = 'https://ejemplo.com/fotos/suite1-actualizada.jpg';


--Consultar fotos
CREATE PROCEDURE ConsultarFotosHabitacion
    @idTipoHabitacion INT = NULL
AS
BEGIN
    SELECT * FROM FotosHabitacion
    WHERE (@idTipoHabitacion IS NULL OR idTipoHabitacion = @idTipoHabitacion);
END;

--Parametros
EXEC ConsultarFotosHabitacion;
EXEC ConsultarFotosHabitacion @idTipoHabitacion = 2;

----------------------------------------------------------------------------

--Agregar comodidad
CREATE PROCEDURE AgregarComodidadHabitacion
    @idTipoHabitacion INT,
    @Descripcion NVARCHAR(150)
AS
BEGIN
    INSERT INTO Comodidades (idTipoHabitacion, Descripcion)
    VALUES (@idTipoHabitacion, @Descripcion);
END;

--Parametros
EXEC AgregarComodidadHabitacion
    @idTipoHabitacion = 1,
    @Descripcion = N'Aire acondicionado';


--Eliminar comodidad
CREATE PROCEDURE EliminarComodidadHabitacion
    @idComodidadHabitacion INT
AS
BEGIN
    DELETE FROM Comodidades
    WHERE idComodidadHabitacion = @idComodidadHabitacion;
END;

--Parametros
EXEC EliminarComodidadHabitacion
    @idComodidadHabitacion = 3;


--Modificar comodidad
CREATE PROCEDURE ModificarComodidadHabitacion
    @idComodidadHabitacion INT,
    @idTipoHabitacion INT,
    @Descripcion NVARCHAR(150)
AS
BEGIN
    UPDATE Comodidades
    SET idTipoHabitacion = @idTipoHabitacion,
        Descripcion = @Descripcion
    WHERE idComodidadHabitacion = @idComodidadHabitacion;
END;

--Parametros
EXEC ModificarComodidadHabitacion
    @idComodidadHabitacion = 3,
    @idTipoHabitacion = 1,
    @Descripcion = N'Televisor Smart';


--Consultar comodidades
CREATE PROCEDURE ConsultarComodidadesHabitacion
    @idTipoHabitacion INT = NULL
AS
BEGIN
    SELECT * FROM Comodidades
    WHERE (@idTipoHabitacion IS NULL OR idTipoHabitacion = @idTipoHabitacion);
END;

--Parametros
EXEC ConsultarComodidadesHabitacion;
EXEC ConsultarComodidadesHabitacion @idTipoHabitacion = 1;

---------------------------------------------------------------------------

--Agregar habitacion
CREATE PROCEDURE AgregarHabitacion
    @idHotel INT,
    @idTipoHabitacion INT,
    @Numero VARCHAR(20)
AS
BEGIN
    INSERT INTO DatosHabitaciones (idHotel, idTipoHabitacion, Numero)
    VALUES (@idHotel, @idTipoHabitacion, @Numero);
END;


--Parametros
EXEC AgregarHabitacion
    @idHotel = 1,
    @idTipoHabitacion = 2,
    @Numero = '305B';


--Eliminar habitacion
CREATE PROCEDURE EliminarHabitacion
    @idHabitacion INT
AS
BEGIN
    DELETE FROM DatosHabitaciones
    WHERE idHabitacion = @idHabitacion;
END;

--Parametros
EXEC EliminarHabitacion
    @idHabitacion = 4;


--Modificar habitación
CREATE PROCEDURE ModificarHabitacion
    @idHabitacion INT,
    @idHotel INT,
    @idTipoHabitacion INT,
    @Numero VARCHAR(20)
AS
BEGIN
    UPDATE DatosHabitaciones
    SET idHotel = @idHotel,
        idTipoHabitacion = @idTipoHabitacion,
        Numero = @Numero
    WHERE idHabitacion = @idHabitacion;
END;

--Parametros
EXEC ModificarHabitacion
    @idHabitacion = 4,
    @idHotel = 1,
    @idTipoHabitacion = 3,
    @Numero = '307C';


--Consultar habitaciones
CREATE PROCEDURE ConsultarHabitaciones
    @idHotel INT = NULL,
    @idTipoHabitacion INT = NULL
AS
BEGIN
    SELECT * FROM DatosHabitaciones
    WHERE (@idHotel IS NULL OR idHotel = @idHotel)
      AND (@idTipoHabitacion IS NULL OR idTipoHabitacion = @idTipoHabitacion);
END;

--Parametros
EXEC ConsultarHabitaciones;
EXEC ConsultarHabitaciones @idHotel = 1;
EXEC ConsultarHabitaciones @idTipoHabitacion = 2;

--------------------------------------------------------------------------

--Agregar cliente
CREATE PROCEDURE AgregarCliente
    @Nombre VARCHAR(50),
    @PrimerApellido VARCHAR(50),
    @SegundoApellido VARCHAR(50),
    @FechaNacimiento DATE,
    @TipoIdentificacion VARCHAR(30),
    @Cedula VARCHAR(30),
    @PaisResidencia VARCHAR(50),
    @Provincia VARCHAR(50),
    @Canton VARCHAR(50),
    @Distrito VARCHAR(50),
    @Telefono1 VARCHAR(20),
    @Telefono2 VARCHAR(20) = NULL,
    @Telefono3 VARCHAR(20) = NULL,
    @CorreoElectronico VARCHAR(100),
    @Activo BIT = 1
AS
BEGIN
    -- Opcional: validar que no exista cedula duplicada
    IF EXISTS (SELECT 1 FROM Cliente WHERE Cedula = @Cedula)
    BEGIN
        RAISERROR('Ya existe un cliente con esa cedula.', 16, 1);
        RETURN;
    END

    INSERT INTO Cliente (Nombre, PrimerApellido, SegundoApellido, FechaNacimiento, TipoIdentificacion, Cedula, PaisResidencia, Provincia, Canton, Distrito, Telefono1, Telefono2, Telefono3, CorreoElectronico, Activo)
    VALUES (@Nombre, @PrimerApellido, @SegundoApellido, @FechaNacimiento, @TipoIdentificacion, @Cedula, @PaisResidencia, @Provincia, @Canton, @Distrito, @Telefono1, @Telefono2, @Telefono3, @CorreoElectronico, @Activo);
END;


--Parametros
EXEC AgregarCliente
    @Nombre = 'Carlos',
    @PrimerApellido = 'Jiménez',
    @SegundoApellido = 'Solano',
    @FechaNacimiento = '1990-05-15',
    @TipoIdentificacion = 'Nacional',
    @Cedula = '123456789',
    @PaisResidencia = 'Costa Rica',
    @Provincia = 'San José',
    @Canton = 'Central',
    @Distrito = 'Carmen',
    @Telefono1 = '8888-8888',
    @Telefono2 = NULL,
    @Telefono3 = NULL,
    @CorreoElectronico = 'carlos@example.com',
	@Activo = 1;


--Eliminar cliente por ID
CREATE PROCEDURE EliminarCliente
    @idCliente INT
AS
BEGIN
    DELETE FROM Cliente
    WHERE idCliente = @idCliente;
END;

--Parametros
EXEC EliminarCliente @idCliente = 1;


--Modificar cliente
CREATE PROCEDURE ModificarCliente
    @idCliente INT,
    @Nombre VARCHAR(50),
    @PrimerApellido VARCHAR(50),
    @SegundoApellido VARCHAR(50),
    @FechaNacimiento DATE,
    @TipoIdentificacion VARCHAR(30),
    @Cedula VARCHAR(30),
    @PaisResidencia VARCHAR(50),
    @Provincia VARCHAR(50),
    @Canton VARCHAR(50),
    @Distrito VARCHAR(50),
    @Telefono1 VARCHAR(20),
    @Telefono2 VARCHAR(20) = NULL,
    @Telefono3 VARCHAR(20) = NULL,
    @CorreoElectronico VARCHAR(100),
    @Activo BIT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Cliente WHERE idCliente = @idCliente)
    BEGIN
        RAISERROR('No se encontro el cliente especificado.', 16, 1);
        RETURN;
    END

    -- Valida que no exista otra cedula igual para diferente cliente
    IF EXISTS (SELECT 1 FROM Cliente WHERE Cedula = @Cedula AND idCliente <> @idCliente)
    BEGIN
        RAISERROR('Otro cliente ya tiene registrada esa cedula.', 16, 1);
        RETURN;
    END

    UPDATE Cliente
    SET Nombre = @Nombre,
        PrimerApellido = @PrimerApellido,
        SegundoApellido = @SegundoApellido,
        FechaNacimiento = @FechaNacimiento,
        TipoIdentificacion = @TipoIdentificacion,
        Cedula = @Cedula,
        PaisResidencia = @PaisResidencia,
        Provincia = @Provincia,
        Canton = @Canton,
        Distrito = @Distrito,
        Telefono1 = @Telefono1,
        Telefono2 = @Telefono2,
        Telefono3 = @Telefono3,
        CorreoElectronico = @CorreoElectronico,
        Activo = @Activo
    WHERE idCliente = @idCliente;
END;

--Parametros
EXEC ModificarCliente
    @idCliente = 1,
    @Nombre = 'Carlos Andrés',
    @PrimerApellido = 'Jiménez',
    @SegundoApellido = 'Solano',
    @FechaNacimiento = '1990-05-15',
    @TipoIdentificacion = 'Nacional',
    @Cedula = '123456789',
    @PaisResidencia = 'Costa Rica',
    @Provincia = 'San José',
    @Canton = 'Central',
    @Distrito = 'Carmen',
    @Telefono1 = '8888-8888',
    @Telefono2 = '2222-2222',
    @Telefono3 = NULL,
    @CorreoElectronico = 'carlos@example.com',
	@Activo = 1;


--Consultar clientes
CREATE PROCEDURE ConsultarClientes
    @Cedula VARCHAR(30) = NULL,
    @Nombre VARCHAR(50) = NULL,
    @CorreoElectronico VARCHAR(100) = NULL
AS
BEGIN
    SELECT * FROM Cliente
    WHERE (@Cedula IS NULL OR Cedula = @Cedula)
      AND (@Nombre IS NULL OR Nombre LIKE '%' + @Nombre + '%')
      AND (@CorreoElectronico IS NULL OR CorreoElectronico LIKE '%' + @CorreoElectronico + '%');
END;

--Parametros
EXEC ConsultarClientes @Cedula = '123456789';

-----------------------------------------------------------------------------------

--Agregar Reservacion
create PROCEDURE AgregarReservacion
    @idCliente INT,
    @idHabitacion INT,
    @FechaIngreso DATETIME,
    @FechaSalida DATETIME,
    @CantidadPersonas INT,
    @Vehiculo VARCHAR(50)
AS
BEGIN
    -- Validar hora de salida
    IF DATEPART(HOUR, @FechaSalida) > 12
    BEGIN
        RAISERROR('La hora de salida no puede ser después del mediodía (12:00 p.m.).', 16, 1);
        RETURN;
    END;

    INSERT INTO Reservaciones (idCliente, idHabitacion, FechaIngreso, FechaSalida, CantidadPersonas, Vehiculo)
    VALUES (@idCliente, @idHabitacion, @FechaIngreso, @FechaSalida, @CantidadPersonas, @Vehiculo);

    -- Retornar numero de reserva para informacion del personal y cliente 
    SELECT SCOPE_IDENTITY() AS NumeroReserva;
END;


--Parametros
EXEC AgregarReservacion 
    @idCliente = 1,
    @idHabitacion = 3,
    @FechaIngreso = '2025-05-10',
    @FechaSalida = '2025-05-15',
    @CantidadPersonas = 2,
    @Vehiculo = 'Toyota Corolla';


--Modificar Reservacion
CREATE PROCEDURE ModificarReservacion
    @idReserva INT,
    @idCliente INT,
    @idHabitacion INT,
    @FechaIngreso DATETIME,
    @FechaSalida DATETIME,
    @CantidadPersonas INT,
    @Vehiculo VARCHAR(50)
AS
BEGIN
    UPDATE Reservaciones
    SET idCliente = @idCliente,
        idHabitacion = @idHabitacion,
        FechaIngreso = @FechaIngreso,
        FechaSalida = @FechaSalida,
        CantidadPersonas = @CantidadPersonas,
        Vehiculo = @Vehiculo
    WHERE idReserva = @idReserva;
END;

--Parametros
EXEC ModificarReservacion 
    @idReserva = 1,
    @idCliente = 1,
    @idHabitacion = 3,
    @FechaIngreso = '2025-05-12',
    @FechaSalida = '2025-05-18',
    @CantidadPersonas = 3,
    @Vehiculo = 'Nissan Versa';


--Eliminar Reservacion
CREATE PROCEDURE EliminarReservacion
    @idReserva INT
AS
BEGIN
    DELETE FROM Reservaciones
    WHERE idReserva = @idReserva;
END;

--Parametros
EXEC EliminarReservacion 
    @idReserva = 1;


--Consultar Reservaciones
CREATE PROCEDURE ConsultarReservaciones
    @idCliente INT = NULL,
    @idHabitacion INT = NULL
AS
BEGIN
    SELECT * FROM Reservaciones
    WHERE (@idCliente IS NULL OR idCliente = @idCliente)
      AND (@idHabitacion IS NULL OR idHabitacion = @idHabitacion);
END;

--Parametros
EXEC ConsultarReservaciones;
EXEC ConsultarReservaciones 
    @idCliente = 1;
EXEC ConsultarReservaciones 
    @idHabitacion = 3;
EXEC ConsultarReservaciones 
    @idCliente = 1,
    @idHabitacion = 3;

---------------------------------------------------------------------------------------------------

--Agregar una factura
CREATE PROCEDURE AgregarFactura
    @idReserva INT,
    @FechaFacturacion DATETIME,
    @TotalPagar DECIMAL(10,2),
    @MetodoPago VARCHAR(50)
AS
BEGIN
    INSERT INTO Facturas (idReserva, FechaFacturacion, TotalPagar, MetodoPago)
    VALUES (@idReserva, @FechaFacturacion, @TotalPagar, @MetodoPago);
END;


--Parametros 
EXEC AgregarFactura 
    @idReserva = 3,
    @FechaFacturacion = '2025-05-01',
    @TotalPagar = 120.50,
    @MetodoPago = 'Tarjeta de crédito';


--Modificar una factura
GO
CREATE PROCEDURE ModificarFactura
    @idFactura INT,
    @idReserva INT,
    @FechaFacturacion DATETIME,
    @TotalPagar DECIMAL(10,2),
    @MetodoPago VARCHAR(50)
AS
BEGIN
    UPDATE Facturas
    SET idReserva = @idReserva,
        FechaFacturacion = @FechaFacturacion,
        TotalPagar = @TotalPagar,
        MetodoPago = @MetodoPago
    WHERE idFactura = @idFactura;
END;
GO

--Parametros
EXEC ModificarFactura 
    @idFactura = 1,
    @idReserva = 1,
    @FechaFacturacion = '2025-05-02',
    @TotalPagar = 150.75,
    @MetodoPago = 'Efectivo';

--Eliminar una factura
CREATE PROCEDURE EliminarFactura
    @idFactura INT
AS
BEGIN
    DELETE FROM Facturas WHERE idFactura = @idFactura;
END;

--Parametros
EXEC EliminarFactura @idFactura = 1;


--Consultar facturas por reserva
CREATE PROCEDURE VerFacturaPorReserva
    @idReserva INT
AS
BEGIN
    SELECT 
        F.idFactura,
        F.FechaFacturacion,
        F.TotalPagar,
        F.MetodoPago,
        R.idHabitacion,
        DH.Numero AS NumeroHabitacion,
        TH.Nombre AS TipoHabitacion,
        DATEDIFF(DAY, R.FechaIngreso, R.FechaSalida) AS NochesHospedadas
    FROM Facturas F
    INNER JOIN Reservaciones R ON F.idReserva = R.idReserva
    INNER JOIN DatosHabitaciones DH ON R.idHabitacion = DH.idHabitacion
    INNER JOIN TipoHabitacion TH ON DH.idTipoHabitacion = TH.idTipoHabitacion
    WHERE F.idReserva = @idReserva;
END;

--Parametros
EXEC VerFacturaPorReserva @idReserva = 5;

----------------------------------------------------------------------------------------------------------------

--Agregar Empresa De Recreacion
CREATE PROCEDURE AgregarEmpresaRecreacion
    @NombreEmpresa VARCHAR(100),
    @CedulaJuridica VARCHAR(20),
    @CorreoElectronico VARCHAR(100),
    @Telefono VARCHAR(20),
    @NombrePersonaContacto VARCHAR(100),
    @Provincia VARCHAR(50),
    @Canton VARCHAR(50),
    @Distrito VARCHAR(50),
    @SennasExactas VARCHAR(250)
AS
BEGIN
    INSERT INTO EmpresasRecreaciones (NombreEmpresa, CedulaJuridica, CorreoElectronico, Telefono, NombrePersonaContacto, Provincia, Canton, Distrito, SennasExactas)
    VALUES (@NombreEmpresa, @CedulaJuridica, @CorreoElectronico, @Telefono, @NombrePersonaContacto, @Provincia, @Canton, @Distrito, @SennasExactas);
END;

--Parametros
EXEC AgregarEmpresaRecreacion
    @NombreEmpresa = 'Recreaciones Limon',
    @CedulaJuridica = '123456789012',
    @CorreoElectronico = 'contacto@recreacioneslimon.com',
    @Telefono = '88888888',
    @NombrePersonaContacto = 'Juan Pérez',
    @Provincia = 'Limon',
    @Canton = 'Limon',
    @Distrito = 'Centro',
    @SennasExactas = 'A 100 metros del parque central';


--Modificar Empresa De Recreacion
CREATE PROCEDURE ModificarEmpresaRecreacion
    @idEmpresaRecreacion INT,
    @NombreEmpresa VARCHAR(100),
    @CedulaJuridica VARCHAR(20),
    @CorreoElectronico VARCHAR(100),
    @Telefono VARCHAR(20),
    @NombrePersonaContacto VARCHAR(100),
    @Provincia VARCHAR(50),
    @Canton VARCHAR(50),
    @Distrito VARCHAR(50),
    @SennasExactas VARCHAR(250)
AS
BEGIN
    -- Verificar si la cedula ya existe para otra empresa
    IF EXISTS (SELECT 1 FROM EmpresasRecreaciones WHERE CedulaJuridica = @CedulaJuridica AND idEmpresaRecreaciones != @idEmpresaRecreacion)
    BEGIN
        PRINT 'Error: La cedula juridica ya está registrada para otra empresa.';
        RETURN;
    END

    -- Si no existe, se procede con la actualización
    UPDATE EmpresasRecreaciones
    SET 
        NombreEmpresa = @NombreEmpresa,
        CedulaJuridica = @CedulaJuridica,
        CorreoElectronico = @CorreoElectronico,
        Telefono = @Telefono,
        NombrePersonaContacto = @NombrePersonaContacto,
        Provincia = @Provincia,
        Canton = @Canton,
        Distrito = @Distrito,
        SennasExactas = @SennasExactas
    WHERE idEmpresaRecreaciones = @idEmpresaRecreacion;
END;



--Parametros
EXEC ModificarEmpresaRecreacion
    @idEmpresaRecreacion = 1,
    @NombreEmpresa = 'Recreaciones Limon Actualizadas',
    @CedulaJuridica = '7890123456',
    @CorreoElectronico = 'nuevo@recreacioneslimon.com',
    @Telefono = '77777777',
    @NombrePersonaContacto = 'María González',
    @Provincia = 'Limon',
    @Canton = 'Limon',
    @Distrito = 'Centro',
    @SennasExactas = 'A 200 metros del parque central';


--
CREATE PROCEDURE EliminarEmpresaRecreacion
    @idEmpresaRecreacion INT
AS
BEGIN
    -- Primero eliminamos las actividades asociadas
    DELETE FROM ActividadRecreaciones
    WHERE idEmpresaRecreaciones = @idEmpresaRecreacion;

    -- Luego eliminamos la empresa recreativa
    DELETE FROM EmpresasRecreaciones
    WHERE idEmpresaRecreaciones = @idEmpresaRecreacion;
END;

-- Parametros
EXEC EliminarEmpresaRecreacion @idEmpresaRecreacion = 1;


--Consultar Empresas Recreacion
CREATE PROCEDURE ConsultarEmpresasRecreacion
    @idEmpresaRecreacion INT = NULL,
    @NombreEmpresa VARCHAR(100) = NULL,
    @CedulaJuridica VARCHAR(20) = NULL,
    @Provincia VARCHAR(50) = NULL,
    @Canton VARCHAR(50) = NULL,
    @Distrito VARCHAR(50) = NULL,
    @Telefono VARCHAR(20) = NULL  
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX)

   
    SET @SQL = 'SELECT * FROM EmpresasRecreaciones WHERE 1=1'
   
    IF @idEmpresaRecreacion IS NOT NULL
        SET @SQL = @SQL + ' AND idEmpresaRecreacion = @idEmpresaRecreacion'

    IF @NombreEmpresa IS NOT NULL
        SET @SQL = @SQL + ' AND NombreEmpresa LIKE ''%'' + @NombreEmpresa + ''%'''

    IF @CedulaJuridica IS NOT NULL
        SET @SQL = @SQL + ' AND CedulaJuridica LIKE ''%'' + @CedulaJuridica + ''%'''

    IF @Provincia IS NOT NULL
        SET @SQL = @SQL + ' AND Provincia LIKE ''%'' + @Provincia + ''%'''

    IF @Canton IS NOT NULL
        SET @SQL = @SQL + ' AND Canton LIKE ''%'' + @Canton + ''%'''

    IF @Distrito IS NOT NULL
        SET @SQL = @SQL + ' AND Distrito LIKE ''%'' + @Distrito + ''%'''

    IF @Telefono IS NOT NULL
        SET @SQL = @SQL + ' AND Telefono LIKE ''%'' + @Telefono + ''%''' 

 
    EXEC sp_executesql @SQL,
        N'@idEmpresaRecreacion INT, @NombreEmpresa VARCHAR(100), @CedulaJuridica VARCHAR(20), @Provincia VARCHAR(50), @Canton VARCHAR(50), @Distrito VARCHAR(50), @Telefono VARCHAR(20)',
        @idEmpresaRecreacion, @NombreEmpresa, @CedulaJuridica, @Provincia, @Canton, @Distrito, @Telefono
END;

--Parametros
EXEC ConsultarEmpresasRecreacion;  
EXEC ConsultarEmpresasRecreacion @NombreEmpresa = 'Recreaciones Limon';
EXEC ConsultarEmpresasRecreacion @Provincia = 'Limon';
EXEC ConsultarEmpresasRecreacion @Canton = 'Limon', @Distrito = 'Centro';
EXEC ConsultarEmpresasRecreacion @Telefono = '88888888';  


----------------------------------------------------------------------------------------------------------------------------

--Agregar Actividad Recreativa
CREATE PROCEDURE AgregarActividadRecreacion
    @idHotel INT,
    @idEmpresaRecreaciones INT,
    @Descripcion VARCHAR(250),
    @Precio DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO ActividadRecreaciones (idHotel, idEmpresaRecreaciones, Descripcion, Precio)
    VALUES (@idHotel, @idEmpresaRecreaciones, @Descripcion, @Precio);
END;

--Parametros
EXEC AgregarActividadRecreacion 
    @idHotel = 2, 
    @idEmpresaRecreaciones = 2, 
    @Descripcion = 'Viaje a la luna', 
    @Precio = 15000.00;


--Modificar Actividad Recreativa
CREATE PROCEDURE ModificarActividadRecreacion
    @idActividad INT,
    @idHotel INT,
    @idEmpresaRecreaciones INT,
    @Descripcion VARCHAR(250),
    @Precio DECIMAL(10, 2)
AS
BEGIN
    UPDATE ActividadRecreaciones
    SET idHotel = @idHotel,
        idEmpresaRecreaciones = @idEmpresaRecreaciones,
        Descripcion = @Descripcion,
        Precio = @Precio
    WHERE idActividad = @idActividad;
END;

--Parametros
EXEC ModificarActividadRecreacion 
    @idActividad = 5, 
    @idHotel = 1, 
    @idEmpresaRecreaciones = 2, 
    @Descripcion = 'Excursión a la montaña', 
    @Precio = 200.00;


--Eliminar Actividad Recreativa
CREATE PROCEDURE EliminarActividadRecreacion
    @idActividad INT
AS
BEGIN
    DELETE FROM ActividadRecreaciones
    WHERE idActividad = @idActividad;
END;

--Parametros
EXEC EliminarActividadRecreacion 
    @idActividad = 5;


--Consultar Actividades Recreativas
CREATE PROCEDURE ConsultarActividadRecreacion
    @idActividad INT = NULL,
    @idHotel INT = NULL,
    @idEmpresaRecreaciones INT = NULL,
    @Descripcion VARCHAR(250) = NULL
AS
BEGIN
    SELECT * FROM ActividadRecreaciones
    WHERE 
        (@idActividad IS NULL OR idActividad = @idActividad)
        AND (@idHotel IS NULL OR idHotel = @idHotel)
        AND (@idEmpresaRecreaciones IS NULL OR idEmpresaRecreaciones = @idEmpresaRecreaciones)
        AND (@Descripcion IS NULL OR Descripcion LIKE '%' + @Descripcion + '%');
END;

--Parametros
EXEC ConsultarActividadRecreacion;
EXEC ConsultarActividadRecreacion @idHotel = 1;
EXEC ConsultarActividadRecreacion @idEmpresaRecreaciones = 1;
EXEC ConsultarActividadRecreacion @Descripcion = 'Paseo';


----------------------------------------------------------------------------------------------------------------------------


---------- Crear Usuario y SuperUsuario ---------------------

-- Crear usuario AdminHotel
CREATE LOGIN AdminHotel WITH PASSWORD = 'Administrador123!';
CREATE USER AdminHotel FOR LOGIN AdminHotel;

-- Crear usuario AdminCliente
CREATE LOGIN AdminCliente WITH PASSWORD = 'Cliente123!';
CREATE USER AdminCliente FOR LOGIN AdminCliente;


-- Permisos sobre tablas relacionadas a hoteles
GRANT SELECT, INSERT, UPDATE, DELETE ON ServicioHospedaje TO AdminHotel;
GRANT SELECT, INSERT, UPDATE, DELETE ON Telefonos TO AdminHotel;
GRANT SELECT, INSERT, UPDATE, DELETE ON RedesSociales TO AdminHotel;
GRANT SELECT, INSERT, UPDATE, DELETE ON TipoHabitacion TO AdminHotel;
GRANT SELECT, INSERT, UPDATE, DELETE ON FotosHabitacion TO AdminHotel;
GRANT SELECT, INSERT, UPDATE, DELETE ON Comodidades TO AdminHotel;
GRANT SELECT, INSERT, UPDATE, DELETE ON DatosHabitaciones TO AdminHotel;
GRANT SELECT, INSERT, UPDATE, DELETE ON ActividadRecreaciones TO AdminHotel;

-- Permiso para ejecutar procedimientos relacionados a hoteles
GRANT EXECUTE ON SCHEMA :: dbo TO [AdminHotel];

-- Cambiar al contexto de AdminCliente
EXECUTE AS USER = 'AdminHotel';
GO

-- Comprobar usuario actual
SELECT USER_NAME() AS UsuarioActual;

-- Probar SELECT (debería funcionar)
SELECT * FROM ServicioHospedaje;

-- Probar ejecutar un procedimiento
EXEC ConsultarClientes;

-- Volver al contexto original
REVERT;
GO


-- Permisos sobre tablas relacionadas a clientes
GRANT SELECT, INSERT, UPDATE, DELETE ON Cliente TO AdminCliente;
GRANT SELECT, INSERT, UPDATE, DELETE ON Reservaciones TO AdminCliente;
GRANT SELECT, INSERT, UPDATE, DELETE ON Facturas TO AdminCliente;
GRANT SELECT, INSERT, UPDATE, DELETE ON EmpresasRecreaciones TO AdminCliente;

-- Permiso para ejecutar procedimientos relacionados
GRANT EXECUTE ON SCHEMA :: dbo TO [AdminCliente];

-- Cambiar al contexto de AdminCliente
EXECUTE AS USER = 'AdminCliente';
GO

-- Comprobar usuario actual
SELECT USER_NAME() AS UsuarioActual;

-- Probar SELECT (debería funcionar)
SELECT * FROM Cliente;

-- Probar ejecutar un procedimiento
EXEC ConsultarClientes;

-- Volver al contexto original
REVERT;
GO

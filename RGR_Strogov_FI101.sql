-- Создание базы данных

-- Таблица для хранения информации о клиентах
CREATE TABLE `Customers` (
  `CustomerID` INT AUTO_INCREMENT PRIMARY KEY,
  `FirstName` VARCHAR(50) NOT NULL,
  `LastName` VARCHAR(50) NOT NULL,
  `Email` VARCHAR(100) NOT NULL,
  `Phone` VARCHAR(20) NOT NULL
);

-- Таблица для хранения информации об оказываемых услугах
CREATE TABLE `Services` (
  `ServiceID` INT AUTO_INCREMENT PRIMARY KEY,
  `ServiceName` VARCHAR(100) NOT NULL,
  `Price` DECIMAL(10,2) NOT NULL
);

-- Таблица для хранения информации о сотрудниках похоронного дома
CREATE TABLE `Employees` (
  `EmployeeID` INT AUTO_INCREMENT PRIMARY KEY,
  `FirstName` VARCHAR(50) NOT NULL,
  `LastName` VARCHAR(50) NOT NULL,
  `Position` VARCHAR(100) NOT NULL
);

-- Таблица для хранения информации о заказах
CREATE TABLE `Orders` (
  `OrderID` INT AUTO_INCREMENT PRIMARY KEY,
  `CustomerID` INT NOT NULL,
  `ServiceID` INT NOT NULL,
  `EmployeeID` INT NOT NULL,
  `OrderDate` DATE NOT NULL,
  CONSTRAINT `fk_CustomerID`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `Customers` (`CustomerID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_ServiceID`
    FOREIGN KEY (`ServiceID`)
    REFERENCES `Services` (`ServiceID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_EmployeeID`
    FOREIGN KEY (`EmployeeID`)
    REFERENCES `Employees` (`EmployeeID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Таблица для хранения информации о платежах
CREATE TABLE `Payments` (
  `PaymentID` INT AUTO_INCREMENT PRIMARY KEY,
  `OrderID` INT NOT NULL,
  `Amount` DECIMAL(10,2) NOT NULL,
  `PaymentDate` DATE NOT NULL,
  CONSTRAINT `fk_OrderID`
    FOREIGN KEY (`OrderID`)
    REFERENCES `Orders` (`OrderID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Ввод данных

INSERT INTO Customers (FirstName, LastName, Email, Phone)
VALUES
('Иван', 'Иванов', 'ivan.ivanov@example.com', '123-456-7890'),
('Мария', 'Петрова', 'maria.petrova@example.com', '987-654-3210'),
('Алексей', 'Смирнов', 'alexey.smirnov@example.com', '555-123-4567'),
('Елена', 'Кузнецова', 'elena.kuznetsova@example.com', '777-888-9999'),
('Дмитрий', 'Сергеев', 'dmitry.sergeev@example.com', '111-222-3333'),
('Анна', 'Федорова', 'anna.fedorova@example.com', '444-555-6666'),
('Владимир', 'Михайлов', 'vladimir.mikhailov@example.com', '999-888-7777'),
('София', 'Шевченко', 'sofia.shevchenko@example.com', '123-987-6543'),
('Артем', 'Васнецов', 'artem.vasnetsov@example.com', '876-543-2109'),
('Екатерина', 'Морозова', 'ekaterina.morozova@example.com', '333-222-1111');

INSERT INTO Services (ServiceName, Price)
VALUES
('Организация похорон', 1000.00),
('Катафалк', 500.50),
('Оформление помещения', 300.00),
('Профессиональный мастер по уходу за телом', 1500.00),
('Музыкальное сопровождение', 200.00),
('Цветочное оформление', 600.00),
('Ритуальные услуги', 1200.75),
('Транспортировка усопшего', 350.25),
('Организация памятных мероприятий', 800.00),
('Работа с документами', 250.50);

INSERT INTO Employees (FirstName, LastName, Position)
VALUES
('Александр', 'Иванов', 'Менеджер по продажам'),
('Екатерина', 'Петрова', 'Администратор'),
('Михаил', 'Смирнов', 'Руководитель церемоний'),
('Анастасия', 'Кузнецова', 'Организатор похорон'),
('Игорь', 'Сергеев', 'Водитель-катафалк'),
('Наталья', 'Федорова', 'Кладовщик'),
('Владислав', 'Михайлов', 'Помощник похорон'),
('Елена', 'Шевченко', 'Координатор мероприятий'),
('Денис', 'Васнецов', 'Мастер по уходу за телом'),
('Ольга', 'Морозова', 'Бухгалтер');

INSERT INTO Orders (CustomerID, ServiceID, EmployeeID, OrderDate)
VALUES
(1, 3, 4, '2024-01-15'),
(2, 1, 2, '2024-01-16'),
(3, 5, 8, '2024-01-17'),
(4, 2, 5, '2024-01-18'),
(5, 7, 1, '2024-01-19'),
(6, 6, 7, '2024-01-20'),
(7, 8, 3, '2024-01-21'),
(8, 9, 10, '2024-01-22'),
(9, 4, 6, '2024-01-23'),
(10, 10, 9, '2024-01-24');

INSERT INTO Payments (OrderID, Amount, PaymentDate)
VALUES
(1, 300.00, '2024-01-25'),
(2, 1000.00, '2024-01-26'),
(3, 200.00, '2024-01-27'),
(4, 500.50, '2024-01-28'),
(5, 1200.75, '2024-01-29'),
(6, 600.00, '2024-01-30'),
(7, 300.25, '2024-01-31'),
(8, 800.00, '2024-02-01'),
(9, 1500.00, '2024-02-02'),
(10, 250.50, '2024-02-03');

-- Функции

-- Функция общей выручки за месяц года
CREATE FUNCTION CalculateMonthlyRevenue(monthParam INT, yearParam INT) RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE totalRevenue DECIMAL(10, 2);

    SELECT SUM(Payments.Amount) INTO totalRevenue
    FROM Payments
    JOIN Orders ON Payments.OrderID = Orders.OrderID
    WHERE MONTH(Orders.OrderDate) = monthParam AND YEAR(Orders.OrderDate) = yearParam;

    RETURN totalRevenue;
END;
-- SELECT CalculateMonthlyRevenue(1, 2024) AS MonthlyRevenue; 

-- Функция вывода ID заказов за указанный период времени
CREATE FUNCTION GetOrdersByPeriod(startDateParam DATE, endDateParam DATE)
RETURNS VARCHAR(255)
BEGIN
    DECLARE orderList VARCHAR(255);

    SELECT GROUP_CONCAT(OrderID) INTO orderList
    FROM Orders
    WHERE OrderDate BETWEEN startDateParam AND endDateParam;

    RETURN orderList;
END;
-- SELECT GetOrdersByPeriod('2024-01-01', '2024-01-31') AS OrdersInJanuary;

-- Функция расчета средней стоимости заказа за всё время 
CREATE FUNCTION CalculateAverageOrderCost() RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE avgOrderCost DECIMAL(10, 2);

    SELECT AVG(Services.Price) INTO avgOrderCost
    FROM Orders
    JOIN Services ON Orders.ServiceID = Services.ServiceID;

    RETURN avgOrderCost;
END;

-- SELECT CalculateAverageOrderCost() AS AverageOrderCost;

-- Триггеры 

-- -----------Customers
-- Триггер перед вставкой, проверяющий наличие электронной почты
CREATE TRIGGER before_insert_Customers
BEFORE INSERT ON Customers
FOR EACH ROW
BEGIN
    IF NEW.Email IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email cannot be NULL';
    END IF;
END;

-- Триггер перед обновлением, запрещающий изменение идентификатора клиента
CREATE TRIGGER before_update_Customers
BEFORE UPDATE ON Customers
FOR EACH ROW
BEGIN
    IF NEW.CustomerID != OLD.CustomerID THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'CustomerID cannot be modified';
    END IF;
END;

-- Триггер перед удалением, запрещающий удаление клиента с активными заказами
CREATE TRIGGER before_delete_Customers
BEFORE DELETE ON Customers
FOR EACH ROW
BEGIN
    DECLARE order_count INT;
    SELECT COUNT(*) INTO order_count FROM Orders WHERE CustomerID = OLD.CustomerID;
    IF order_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete customer with active orders';
    END IF;
END;

-- -----------Services
-- Триггер перед вставкой, проверяющий положительную цену услуги
CREATE TRIGGER before_insert_Services
BEFORE INSERT ON Services
FOR EACH ROW
BEGIN
    IF NEW.Price <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Price must be greater than zero';
    END IF;
END;

-- Триггер перед обновлением, запрещающий изменение идентификатора услуги
CREATE TRIGGER before_update_Services
BEFORE UPDATE ON Services
FOR EACH ROW
BEGIN
    IF NEW.ServiceID != OLD.ServiceID THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ServiceID cannot be modified';
    END IF;
END;

-- Триггер перед удалением, запрещающий удаление услуги, используемой в заказах
CREATE TRIGGER before_delete_Services
BEFORE DELETE ON Services
FOR EACH ROW
BEGIN
    DECLARE order_count INT;
    SELECT COUNT(*) INTO order_count FROM Orders WHERE ServiceID = OLD.ServiceID;
    IF order_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete service used in orders';
    END IF;
END;

-- -----------Employees
-- Триггер перед вставкой, проверяющий должность сотрудника
CREATE TRIGGER before_insert_Employees
BEFORE INSERT ON Employees
FOR EACH ROW
BEGIN
    IF NEW.Position IS NULL OR NEW.Position = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Position cannot be NULL or empty';
    END IF;
END;

-- Триггер перед обновлением, запрещающий изменение идентификатора сотрудника
CREATE TRIGGER before_update_Employees
BEFORE UPDATE ON Employees
FOR EACH ROW
BEGIN
    IF NEW.EmployeeID != OLD.EmployeeID THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'EmployeeID cannot be modified';
    END IF;
END;

-- Триггер перед удалением, запрещающий удаление сотрудника с активными заказами
CREATE TRIGGER before_delete_Employees
BEFORE DELETE ON Employees
FOR EACH ROW
BEGIN
    DECLARE order_count INT;
    SELECT COUNT(*) INTO order_count FROM Orders WHERE EmployeeID = OLD.EmployeeID;
    IF order_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete employee with active orders';
    END IF;
END;

-- -----------Orders
-- Триггер перед вставкой, проверяющий наличие даты заказа
CREATE TRIGGER before_insert_Orders
BEFORE INSERT ON Orders
FOR EACH ROW
BEGIN
    IF NEW.OrderDate IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'OrderDate cannot be NULL';
    END IF;
END;

-- Триггер перед обновлением, запрещающий изменение идентификатора заказа
CREATE TRIGGER before_update_Orders
BEFORE UPDATE ON Orders
FOR EACH ROW
BEGIN
    IF NEW.OrderID != OLD.OrderID THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'OrderID cannot be modified';
    END IF;
END;

-- Триггер перед удалением, запрещающий удаление заказа с платежами
CREATE TRIGGER before_delete_Orders
BEFORE DELETE ON Orders
FOR EACH ROW
BEGIN
    DECLARE payment_count INT;
    SELECT COUNT(*) INTO payment_count FROM Payments WHERE OrderID = OLD.OrderID;
    IF payment_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete order with payments';
    END IF;
END;

-- -----------Payments
-- Триггер перед вставкой, проверяющий положительную сумму платежа
CREATE TRIGGER before_insert_Payments
BEFORE INSERT ON Payments
FOR EACH ROW
BEGIN
    IF NEW.Amount <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Amount must be greater than zero';
    END IF;
END;

-- Триггер перед обновлением, запрещающий изменение идентификатора платежа
CREATE TRIGGER before_update_Payments
BEFORE UPDATE ON Payments
FOR EACH ROW
BEGIN
    IF NEW.PaymentID != OLD.PaymentID THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'PaymentID cannot be modified';
    END IF;
END;
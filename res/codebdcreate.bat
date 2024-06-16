CREATE TABLE [Order](
    order_id INT PRIMARY KEY identity,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) on delete cascade on update cascade,
);
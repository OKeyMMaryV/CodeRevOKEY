﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущаяСтраница", "ГруппаРасчеты");
	
	ОткрытьФорму(
		"Обработка.ФункциональностьПрограммы.Форма.ФормаФункциональностьПрограммы",
		ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник, 
		Истина, 
		ПараметрыВыполненияКоманды.Окно, 
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

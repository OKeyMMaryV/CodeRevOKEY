﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	//Вставить содержимое обработчика.
	//ПараметрыФормы = Новый Структура("", );
	//ОткрытьФорму("Документ.УведомлениеОбОстаткахПрослеживаемыхТоваров.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Основание", ПараметрКоманды);
	
	ОткрытьФорму("Документ.УведомлениеОбОстаткахПрослеживаемыхТоваров.Форма.ФормаДокументаКорректировочная", ПараметрыФормы,,,,);
	
КонецПроцедуры

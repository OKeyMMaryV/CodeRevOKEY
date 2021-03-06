
&НаКлиенте
Процедура КомандаОК(Команда)
	
	Закрыть(УпаковатьТаблицу());
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИмяТабличнойЧасти = Параметры.ИмяТабличнойЧасти;
	
	Заголовок = "Периоды действия";
	Если ИмяТабличнойЧасти = "ок_ПериодыДействияВходящие" Тогда
		Заголовок = "Периоды действия входящие";
	ИначеЕсли ИмяТабличнойЧасти = "ок_ПериодыДействияИсходящие" Тогда
		Заголовок = "Периоды действия исходящие";
	КонецЕсли;	
	
	ДанныеПериодыДействия = Параметры.ПериодыДействия;
	ПериодыДействия.Очистить();
	Для каждого Строка из ДанныеПериодыДействия Цикл
		ЗаполнитьЗначенияСвойств(ПериодыДействия.Добавить(), Строка);
	КонецЦикла;	
	
КонецПроцедуры

&НаСервере
Функция УпаковатьТаблицу()
	
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(ПериодыДействия.Выгрузить());
	
КонецФункции	
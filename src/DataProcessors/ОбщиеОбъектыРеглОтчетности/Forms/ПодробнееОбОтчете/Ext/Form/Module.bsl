﻿
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	НачальноеЗначениеВыбора = Параметры.НачальноеЗначениеВыбора;
	
	КлючевыеСловаПериодов = Новый СписокЗначений;
	КлючевыеСловаПериодов.Добавить("Месяц", "ежемесячно");
	КлючевыеСловаПериодов.Добавить("Квартал", "ежеквартально");
	КлючевыеСловаПериодов.Добавить("Полугодие", "по полугодиям");
	КлючевыеСловаПериодов.Добавить("Год", "ежегодно");

	КромеМесяца = Новый СписокЗначений;
	КромеМесяца.Добавить(1, "января");
	КромеМесяца.Добавить(2, "февраля");
	КромеМесяца.Добавить(3, "марта");
	КромеМесяца.Добавить(4, "апреля");
	КромеМесяца.Добавить(5, "мая");
	КромеМесяца.Добавить(6, "июня");
	КромеМесяца.Добавить(7, "июля");
	КромеМесяца.Добавить(8, "августа");
	КромеМесяца.Добавить(9, "сентября");
	КромеМесяца.Добавить(10, "октября");
	КромеМесяца.Добавить(11, "ноября");
	КромеМесяца.Добавить(12, "декабря");
	
	КромеКвартала = Новый СписокЗначений;
	КромеКвартала.Добавить(1, "1-го квартала");
	КромеКвартала.Добавить(2, "2-го квартала");
	КромеКвартала.Добавить(3, "3-го квартала");
	КромеКвартала.Добавить(4, "4-го квартала");
	
	КромеПолугодия = Новый СписокЗначений;
	КромеПолугодия.Добавить(1, "1-го полугодия");
	КромеПолугодия.Добавить(2, "2-го полугодия");
	
	Кроме = Новый Структура("Месяц, Квартал, Полугодие, Год", КромеМесяца, КромеКвартала, КромеПолугодия, Новый СписокЗначений);

	ОшибкаПолученияСпискаФорм = Ложь;
	Попытка
		Попытка
			ТаблицаФормОтчета = Отчеты[НачальноеЗначениеВыбора.ИсточникОтчета].ТаблицаФормОтчета().Скопировать();
			
			КЧ = Новый КвалификаторыЧисла(1, 0);
			Массив = Новый Массив;
			Массив.Добавить(Тип("Число"));
			ОписаниеТиповЧ = Новый ОписаниеТипов(Массив, , ,КЧ);
			ТаблицаФормОтчета.Колонки.Добавить("ИндексКартинки", ОписаниеТиповЧ);
			ЗначениеВДанныеФормы(ТаблицаФормОтчета, ФормыОтчета);
		Исключение
			ОшибкаПолученияСпискаФорм = Истина;
		КонецПопытки;
		Если ОшибкаПолученияСпискаФорм Тогда
			ВызватьИсключение Неопределено;
		КонецЕсли;
		
		Попытка
			ДеревоФормИФорматов = Отчеты[НачальноеЗначениеВыбора.ИсточникОтчета].ДеревоФормИФорматов();
			Если ДеревоФормИФорматов.Строки.Количество() = 0 Тогда
				ДеревоФормИФорматов = Неопределено;
			КонецЕсли;
		Исключение
			ДеревоФормИФорматов = Неопределено;
		КонецПопытки;
		
		Для Каждого Элемент Из ФормыОтчета Цикл
			
			Если (ТекущаяДатаСеанса() > Элемент.ДатаНачалоДействия ИЛИ НЕ ЗначениеЗаполнено(Элемент.ДатаНачалоДействия)) 
			   И (ТекущаяДатаСеанса() < Элемент.ДатаКонецДействия ИЛИ НЕ ЗначениеЗаполнено(Элемент.ДатаКонецДействия)) Тогда
			
				Элемент.ИндексКартинки = 0;
				
			Иначе
				
				Элемент.ИндексКартинки = 1;
				
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(Элемент.ДатаКонецДействия) Тогда
				Элемент.ДатаКонецДействия = "По наст. время";
			КонецЕсли;
			
			Если ДеревоФормИФорматов <> Неопределено Тогда
				
				СтрВерсииФорматов = "";
				
				ПолучитьВерсииФорматовВыгрузкиФормыОтчета(ДеревоФормИФорматов, Элемент, СтрВерсииФорматов);
				
				Если ЗначениеЗаполнено(СтрВерсииФорматов) Тогда
					Элемент.ОписаниеОтчета = Элемент.ОписаниеОтчета + Символы.ПС + СтрВерсииФорматов;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
		ФормыОтчета.Сортировать("ДатаНачалоДействия");
		Элементы.ИнформацияОФормах.ТекущаяСтраница = Элементы.ИнформацияОФормахДоступна;
	Исключение
		Элементы.ФормыОтчета.Доступность = Ложь;
		Элементы.ИнформацияОФормах.ТекущаяСтраница = Элементы.ИнформацияОФормахНеДоступна;
	КонецПопытки;
	
	ИтоговаяСтрока = "";
	Периоды = НачальноеЗначениеВыбора.Периоды.Получить();
	Если Периоды <> Неопределено Тогда
		ТипЗнчПериоды = ТипЗнч(Периоды);
		Если ТипЗнчПериоды = Тип("Структура") Тогда
			ИтоговаяСтрока = ПолучитьСтрокуПредставленияПериодовДляЗаписи(Периоды);
		ИначеЕсли ТипЗнчПериоды = Тип("Соответствие") Тогда
			ТаблицаСтрокПредставлений = Новый ТаблицаЗначений;
			ТаблицаСтрокПредставлений.Колонки.Добавить("НачалоДействия");
			ТаблицаСтрокПредставлений.Колонки.Добавить("КонецДействия");
			ТаблицаСтрокПредставлений.Колонки.Добавить("Представление");
			Для Каждого ЗаписьПериода Из Периоды Цикл
				НовСтр = ТаблицаСтрокПредставлений.Добавить();
				НовСтр.НачалоДействия = ЗаписьПериода.Ключ;
				НовСтр.Представление = ПолучитьСтрокуПредставленияПериодовДляЗаписи(ЗаписьПериода.Значение);
			КонецЦикла;
			ТаблицаСтрокПредставлений.Сортировать("НачалоДействия");
			Для Инд = 0 По ТаблицаСтрокПредставлений.Количество() - 2 Цикл
				ТекСтр = ТаблицаСтрокПредставлений.Получить(Инд);
				СледующаяДатаНачала = ТаблицаСтрокПредставлений.Получить(Инд + 1).НачалоДействия;
				ТекСтр.КонецДействия = СледующаяДатаНачала;
			КонецЦикла;
			Для Каждого Стр Из ТаблицаСтрокПредставлений Цикл
				Если Стр.КонецДействия <> '00010101000000' И Стр.КонецДействия <> Неопределено Тогда
					Стр.КонецДействия = НачалоДня(Стр.КонецДействия - 1);
				КонецЕсли;
			КонецЦикла;
			КолСтрокТаблицыПредставлений = ТаблицаСтрокПредставлений.Количество();
			Для ОбратныйИндекс = 1 По КолСтрокТаблицыПредставлений Цикл
				Стр = ТаблицаСтрокПредставлений.Получить(КолСтрокТаблицыПредставлений - ОбратныйИндекс);
				СтрПериодДействия = "";
				Если Стр.НачалоДействия <> '00010101000000' И Стр.НачалоДействия <> Неопределено Тогда
					СтрПериодДействия = "С " + Формат(Стр.НачалоДействия, "ДФ=dd.MM.yyyy");
				КонецЕсли;
				Если Стр.КонецДействия <> '00010101000000' И Стр.КонецДействия <> Неопределено Тогда
					СтрПериодДействия = СтрПериодДействия + " до " + Формат(Стр.КонецДействия, "ДФ=dd.MM.yyyy");
				КонецЕсли;
				СтрПериодДействия = СокрЛП(СтрПериодДействия);
				Если НЕ ПустаяСтрока(СтрПериодДействия) Тогда
					ИтоговаяСтрока = ИтоговаяСтрока + ВРЕГ(Лев(СтрПериодДействия, 1)) + Сред(СтрПериодДействия, 2) + ": " + нрег(Стр.Представление) + Символы.ПС;
				Иначе
					ИтоговаяСтрока = ИтоговаяСтрока + Стр.Представление + Символы.ПС;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	Иначе
		ИтоговаяСтрока = "Сведения о возможных периодах представления не определены.";
	КонецЕсли;
	НадписьВозможныеПериоды = СокрЛП(ИтоговаяСтрока);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСтрокуПредставленияПериодовДляЗаписи(СтруктураПериодов)
	
	ИтоговаяСтрока = "";
	МассивСтрокиПериоды = Новый Массив;
	КлючевыеСловаПериодов.ЗаполнитьПометки(Ложь);
	Для Каждого Стр Из СтруктураПериодов Цикл
		
		Ключ = Стр.Ключ;
		КлючевоеСлово = Неопределено;
		Для Каждого Эл Из КлючевыеСловаПериодов Цикл
			Если Лев(Ключ, СтрДлина(Эл.Значение)) = Эл.Значение И Эл.Пометка <> Истина Тогда
				КлючевоеСлово = Эл.Значение;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если КлючевоеСлово = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Эл.Пометка = Истина;
		Значение = Стр.Значение;
		Если Значение.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаПериоды = КлючевыеСловаПериодов.НайтиПоЗначению(КлючевоеСлово).Представление;
		ПервыйПериодИсключение = Истина;
		РазрешенныеПериоды = Новый СписокЗначений;
		РазрешенныеПериоды.ЗагрузитьЗначения(Значение);
		Для Каждого Эл Из Кроме[КлючевоеСлово] Цикл
			Если РазрешенныеПериоды.НайтиПоЗначению(Эл.Значение) = Неопределено Тогда
				СтрокаПериоды = СтрокаПериоды + ?(ПервыйПериодИсключение, ", кроме ", ", ") + Эл.Представление;
				ПервыйПериодИсключение = Ложь;
			КонецЕсли;
		КонецЦикла;
		
		ИтоговаяСтрока = ИтоговаяСтрока + СтрокаПериоды + "; ";
		
	КонецЦикла;
	
	Если ПустаяСтрока(ИтоговаяСтрока) Тогда
		ИтоговаяСтрока = "Не представляется.";
	Иначе
		ИтоговаяСтрока = Лев(ИтоговаяСтрока, СтрДлина(ИтоговаяСтрока) - 2);
		ИтоговаяСтрока = ВРег(Лев(ИтоговаяСтрока, 1)) + Сред(ИтоговаяСтрока, 2) + ".";
	КонецЕсли;
	
	Возврат ИтоговаяСтрока;
	
КонецФункции

&НаСервере
Процедура ПолучитьВерсииФорматовВыгрузкиФормыОтчета(ДеревоФормИФорматов, ДанныеФормы, СтрВерсииФорматов)
	
	НайденныеФормы  = Новый Массив;
	ОтобранныеФормы = Новый Массив;
	
	Для Каждого ЭлементФорма Из ДеревоФормИФорматов.Строки Цикл
		Если ВРег(ЭлементФорма.ИмяОбъекта) <> ВРег(ДанныеФормы.ФормаОтчета) Тогда
			Продолжить;
		КонецЕсли;
		
		НайденныеФормы.Добавить(ЭлементФорма);
		
		СтрОписание     = ВРег(ДанныеФормы.ОписаниеОтчета);
		СтрДатаПриказа  = Формат(ЭлементФорма.ДатаПриказа, "ДФ=dd.MM.yyyy");
		СтрНомерПриказа = ВРег(ЭлементФорма.НомерПриказа);
		Если СтрНайти(СтрОписание, СтрДатаПриказа) > 0 ИЛИ СтрНайти(СтрОписание, СтрНомерПриказа) > 0 Тогда
			Если ЭлементФорма.ДатаОкончанияДействия > '00010101000000' И ДанныеФормы.ДатаКонецДействия > '00010101000000' Тогда
				Если ЭлементФорма.ДатаНачалаДействия > КонецДня(ДанныеФормы.ДатаКонецДействия)
				 ИЛИ ЭлементФорма.ДатаОкончанияДействия < НачалоДня(ДанныеФормы.ДатаКонецДействия) Тогда
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			ОтобранныеФормы.Добавить(ЭлементФорма);
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ ЗначениеЗаполнено(НайденныеФормы) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ОтобранныеФормы) Тогда
		ОтобранныеФормы.Добавить(НайденныеФормы[НайденныеФормы.ВГраница()]);
	КонецЕсли;
	
	СтрФорматыВыгрузки = "";
	
	Для Каждого НайденнаяФорма Из ОтобранныеФормы Цикл
		Для Каждого СтрФормат Из НайденнаяФорма.Строки Цикл
			
			ВерсияФормата = СокрЛП(СтрФормат.Код);
			ИмяФайлаСхемы = ВРег(СокрЛП(СтрФормат.ИмяОбъекта));
			
			ВерсияСхемы = "";
			ПозРасширения = СтрНайти(ИмяФайлаСхемы, ".XSD");
			Если ЗначениеЗаполнено(ИмяФайлаСхемы) Тогда
				Если ПозРасширения > 2 Тогда
					ВерсияСхемы = Сред(ИмяФайлаСхемы, ПозРасширения - 2, 2);
				Иначе
					ВерсияСхемы = Прав(ИмяФайлаСхемы, 2);
				КонецЕсли;
			КонецЕсли;
			
			Если СтрНайти(ДанныеФормы.ОписаниеОтчета, ВерсияФормата) > 0 Тогда // в строке уже указан формат
				Продолжить;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ВерсияСхемы) И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ВерсияСхемы) Тогда
				ВерсияФормата = ВерсияФормата + "(" + ВерсияСхемы + ")";
			КонецЕсли;
			
			СтрФорматыВыгрузки = СтрФорматыВыгрузки + ?(ПустаяСтрока(СтрФорматыВыгрузки), "", ", ") + ВерсияФормата;
			
		КонецЦикла;
	КонецЦикла;
	
	Если ПустаяСтрока(СтрФорматыВыгрузки) Тогда
		Возврат;
	КонецЕсли;
	
	Если СтрНайти(СтрФорматыВыгрузки, ", ") > 0 Тогда
		СтрВерсииФорматов = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='XML-форматы выгрузки электронного представления версий: %1.'"), СтрФорматыВыгрузки);
	Иначе
		СтрВерсииФорматов = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='XML-формат выгрузки электронного представления версии: %1.'"), СтрФорматыВыгрузки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаОбъектаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект, Объект);

	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьКэшЗначений();
	
	Период = НачалоМесяца(ТекущаяДатаСеанса());
	ПолучитьСоставПериметраКонсолидации(Период);
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Если это копирование - формируем записи регистра сведений для периметра 
	ИсточникКопирования = фКэшЗначений.ИсточникКопирования;
	Если ИсточникКопирования <> Неопределено Тогда
		
		Оповещение = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект, ИсточникКопирования);
		ТекстВопроса = Нстр("ru = 'Выполнить копирование состава периметра консолидации?'")
						+ Символы.ПС + Нстр("ru = 'Элемент будет при этом записан.'");
						
		// Вопрос пользователю - нужно ли копировать табличную часть.
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 30, КодВозвратаДиалога.Нет);
		
	КонецЕсли;    	
	
КонецПроцедуры // ПриОткрытии()

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ПроверитьЗаполнениеТаблицыЗначений(Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	ЗаписатьСоставПериметраКонсолидации(Отказ, ТекущийОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события "ПриИзменении" поля ввода "Период".
// 
&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	ПолучитьСоставПериметраКонсолидации(Период);
	
КонецПроцедуры

// Процедура - обработчик события "ОбработкаВыбора" поля ввода "Период".
// 
&НаКлиенте
Процедура ПериодОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка, Оповещение)
	
	Если Модифицированность Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПериодОбработкаВыбораЗавершение", ЭтотОбъект, Оповещение);
		ТекстВопроса = НСтр("ru = 'Сохранить значения состава периметров консолидации'") + " " + Период;
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);

	Иначе
		
		Если Оповещение <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(Оповещение);
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура - завершение обработчика события "ОбработкаВыбора" поля ввода "Период".
// 
&НаКлиенте
Процедура ПериодОбработкаВыбораЗавершение(Ответ, Оповещение) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		Записать();
	КонецЕсли;
	
	Если Оповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(Оповещение);
	КонецЕсли; 
	
КонецПроцедуры

// Процедура - обработчик события "Регулирование" поля ввода "Период".
// 
&НаКлиенте
Процедура ПериодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПериодРегулированиеЗавершение", ЭтотОбъект, Направление);
	ПериодОбработкаВыбора(Элементы.Период, Период, Истина, ОписаниеОповещения);	
	
КонецПроцедуры

// Процедура - завершение обработчика события "Регулирование" поля ввода "Период".
// 
&НаКлиенте
Процедура ПериодРегулированиеЗавершение(Результат, Направление) Экспорт
	
	Период = НачалоМесяца(ДобавитьМесяц(Период, Направление));
	ПериодПриИзменении(Элементы.Период);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСоставПериметраКонсолидации

&НаКлиенте
Процедура СоставПериметраКонсолидацииПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	ТекущиеДанные = Элементы.СоставПериметраКонсолидации.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ТекущиеДанные.Период = НачалоМесяца(Период);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоставПериметраКонсолидацииПолнаяДоляВладенияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СоставПериметраКонсолидации.ТекущиеДанные;
	ТекущиеДанные.ДоляНеконтролирующихАкционеров = 100 - ТекущиеДанные.ПолнаяДоляВладения;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьСоставПериметраКонсолидации(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("КомандаОбновитьСоставПериметраКонсолидацииЗавершение", ЭтотОбъект);
	
	ПериодОбработкаВыбора(Элементы.Период, Период, Истина, ОписаниеОповещения);

КонецПроцедуры

// Процедура - завершение обработки команды "ОбновитьСоставПериметраКонсолидации".
// 
&НаКлиенте
Процедура КомандаОбновитьСоставПериметраКонсолидацииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ПериодПриИзменении(Элементы.Период);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет кэш значений доступный на сервере и клиенте.
// 
// Параметры:
//  Нет
// 
&НаСервере
Процедура ЗаполнитьКэшЗначений()

	фКэшЗначений = Новый Структура;
	
	ИсточникКопирования = ?(ЗначениеЗаполнено(Параметры.ЗначениеКопирования), Параметры.ЗначениеКопирования, Неопределено);
	фКэшЗначений.Вставить("ИсточникКопирования", ИсточникКопирования);
            
КонецПроцедуры // ЗаполнитьКэшЗначений()

// Процедура получает состав периметра консолидации.
// 
// Параметры:
//  Период - Дата.
// 
// Возвращаемое значение:
//  Результат - Таблица значений.
// 
&НаСервере
Процедура ПолучитьСоставПериметраКонсолидации(Период)

	Результат = Неопределено;
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	бит_му_СоставПериметровКонсолидацииСрезПоследних.Период,
	               |	бит_му_СоставПериметровКонсолидацииСрезПоследних.Организация,
	               |	бит_му_СоставПериметровКонсолидацииСрезПоследних.ДатаОкончания,
	               |	бит_му_СоставПериметровКонсолидацииСрезПоследних.ТипКонсолидации,
	               |	бит_му_СоставПериметровКонсолидацииСрезПоследних.ПолнаяДоляВладения,
	               |	бит_му_СоставПериметровКонсолидацииСрезПоследних.ДоляНеконтролирующихАкционеров,
	               |	бит_му_СоставПериметровКонсолидацииСрезПоследних.МетодКонсолидации,
	               |	бит_му_СоставПериметровКонсолидацииСрезПоследних.ОсуществляетКонтрольПериметра,
				   // 1c-izhtc, ChuckNorris, 03.07.2015 ( 
				   |	бит_му_СоставПериметровКонсолидацииСрезПоследних.бит_ДатаЛиквидацииКомпании
				   // 1c-izhtc, ChuckNorris, 03.07.2015 )
	               |ИЗ
	               |	РегистрСведений.бит_му_СоставПериметровКонсолидации.СрезПоследних(&Период, ПериметрКонсолидации = &ПериметрКонсолидации) КАК бит_му_СоставПериметровКонсолидацииСрезПоследних
	               |ГДЕ
	               |	(КОНЕЦПЕРИОДА(бит_му_СоставПериметровКонсолидацииСрезПоследних.ДатаОкончания, ДЕНЬ) >= &Период
	               |			ИЛИ бит_му_СоставПериметровКонсолидацииСрезПоследних.ДатаОкончания = &ПустаяДата)";
				   
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Запрос.УстановитьПараметр("Период", 			  Период);
	Запрос.УстановитьПараметр("ПустаяДата",			  Дата('00010101'));
	Запрос.УстановитьПараметр("ПериметрКонсолидации", Объект.Ссылка);
	
	Результат = Запрос.Выполнить().Выгрузить();

	СоставПериметраКонсолидации.Загрузить(Результат);
	
КонецПроцедуры // ПолучитьСоставПериметраКонсолидации()

// Процедура записывает состав периметра консолидации.
// 
// Параметры:
//   Отказ - Булево, по умолчанию Ложь.
//   ПериметрКонсолидации - Справочник объект "бит_му_ПериметрыКонсолидации".
// 
&НаСервере
Процедура ЗаписатьСоставПериметраКонсолидации(Отказ, ПериметрКонсолидации)

	ПериодЗаписи = НачалоМесяца(Период);
	
	Попытка
		
		БлокировкаДанных = Новый БлокировкаДанных;
		ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("РегистрСведений.бит_му_СоставПериметровКонсолидации");
		ЭлементБлокировкиДанных.УстановитьЗначение("ПериметрКонсолидации", ПериметрКонсолидации.Ссылка);
		ЭлементБлокировкиДанных.УстановитьЗначение("Период", ПериодЗаписи);
		ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Исключительный;
		БлокировкаДанных.Заблокировать();
		
		НаборЗаписей = РегистрыСведений.бит_му_СоставПериметровКонсолидации.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ПериметрКонсолидации.Установить(ПериметрКонсолидации.Ссылка);
		НаборЗаписей.Отбор.Период.Установить(ПериодЗаписи);
		
		Для каждого ТекСтр Из СоставПериметраКонсолидации Цикл
			
			Если ТекСтр.Период <> ПериодЗаписи Тогда
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтр);
			
			НоваяСтрока.ПериметрКонсолидации = ПериметрКонсолидации.Ссылка;
		КонецЦикла;
		
		НаборЗаписей.Записать();
		
	Исключение
		
		ОбщегоНазначения.СообщитьПользователю(КраткоеПредставлениеОшибки(ОписаниеОшибки()), ПериметрКонсолидации,,,Отказ);
		
	КонецПопытки;

КонецПроцедуры

// Процедура проверяет, правильно ли заполнена таблица значений "СоставПериметраКонсолидации".
// 
// Параметры:
//  Отказ - Булево, по умолчанию Ложь.
// 
&НаСервере
Процедура ПроверитьЗаполнениеТаблицыЗначений(Отказ)

	// Выполним проверку: есть ли дублирующиеся строки.
	СтрокаОшибок = "";
	
	ТаблицаЗначений = СоставПериметраКонсолидации.Выгрузить();
	ТаблицаЗначений.Колонки.Добавить("Счетчик");
	ТаблицаЗначений.ЗаполнитьЗначения(1, "Счетчик");
	ТаблицаЗначений.Свернуть("Организация", "Счетчик");
	
	Для каждого ТекСтр Из ТаблицаЗначений Цикл
		Если ТекСтр.Счетчик > 1 Тогда
			СтрокаОшибок = СтрокаОшибок + Символы.Таб + НСтр("ru = '- в составе периметра консолидации присутствуют несколько строк с одинаковой организацией ""%1""'") + Символы.ПС;
			СтрокаОшибок = СтрШаблон(СтрокаОшибок, ТекСтр.Организация);
		КонецЕсли;
	КонецЦикла;
	
	// Выполним проверку: флаг "Осуществляет контроль периметра" должен быть установлен хотя бы для одной организации.
	УстановленФлагОсуществляетКонтрольПериметра = СоставПериметраКонсолидации.Количество() = 0;
	
	Для каждого ТекСтр Из СоставПериметраКонсолидации Цикл
		Если ТекСтр.ОсуществляетКонтрольПериметра Тогда
			УстановленФлагОсуществляетКонтрольПериметра = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ УстановленФлагОсуществляетКонтрольПериметра Тогда
		СтрокаОшибок = СтрокаОшибок + Символы.Таб + НСтр("ru = '- ни для одной организации не указан флаг ""%1""'") + Символы.ПС;
		СтрокаОшибок = СтрШаблон(СтрокаОшибок, НСтр("ru = 'ОсуществляетКонтрольПериметра'"));		
	КонецЕсли;	
	
	// Выполним проверку: заполнены ли необходимые реквизиты.
	РеквизитыДляПроверки = Новый Структура;
	РеквизитыДляПроверки.Вставить("Организация", 		НСтр("ru = 'Организация'"));
	РеквизитыДляПроверки.Вставить("ТипКонсолидации", 	НСтр("ru = 'Тип консолидации'"));
	РеквизитыДляПроверки.Вставить("ПолнаяДоляВладения", НСтр("ru = 'Полная доля владения, %'"));
	РеквизитыДляПроверки.Вставить("МетодКонсолидации", 	НСтр("ru = 'Метод консолидации'"));
	
	
	Для каждого ТекСтр Из СоставПериметраКонсолидации Цикл
		Для каждого ТекРеквизит Из РеквизитыДляПроверки Цикл
			
			Если НЕ ЗначениеЗаполнено(ТекСтр[ТекРеквизит.Ключ]) Тогда
				СтрокаОшибок = СтрокаОшибок + Символы.Таб + НСтр("ru = '- в строке № %1 не заполнен реквизит ""%2""'") + Символы.ПС;
				СтрокаОшибок = СтрШаблон(СтрокаОшибок, (СоставПериметраКонсолидации.Индекс(ТекСтр) + 1), ТекРеквизит.Значение);
			КонецЕсли;
			
		КонецЦикла;
		
		Если ТекСтр.ПолнаяДоляВладения > 100 Тогда
			СтрокаОшибок = СтрокаОшибок + Символы.Таб + НСтр("ru = '- в строке № %1% реквизит ""%2%"" не может быть больше 100%'") + Символы.ПС;
			СтрокаОшибок = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(СтрокаОшибок, (СоставПериметраКонсолидации.Индекс(ТекСтр) + 1), НСтр("ru = 'Полная доля владения, %'"));
		КонецЕсли;
	КонецЦикла;
	
	
	// Проверка на на то, чтобы одна и та же элиминирующая компания 
	// в одном и том же периоде не входила более чем в 1 периметр консолидации.
	Запрос = Новый Запрос;
	ТаблицаОрг = СоставПериметраКонсолидации.Выгрузить(, "Организация, ТипКонсолидации");
	Запрос.УстановитьПараметр("ТаблицаОрг" 	 		 , ТаблицаОрг);
	Запрос.УстановитьПараметр("Период"				 , Период);
	Запрос.УстановитьПараметр("ПериметрКонсолидации" , Объект.Ссылка);
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
    |	Табл.Организация
    |ПОМЕСТИТЬ ВремОрганизации
    |ИЗ
    |	&ТаблицаОрг КАК Табл
    |ГДЕ
    |	Табл.ТипКонсолидации = ЗНАЧЕНИЕ(Перечисление.бит_му_ТипыКонсолидации.Консолидирующая)
    |;
    |
    |////////////////////////////////////////////////////////////////////////////////
    |ВЫБРАТЬ
    |	РегСостав.Период,
    |	РегСостав.Организация,
    |	РегСостав.ПериметрКонсолидации,
    |	РегСостав.ДатаОкончания
    |ИЗ
    |	РегистрСведений.бит_му_СоставПериметровКонсолидации.СрезПоследних(
    |			&Период,
    |			Организация В (ВЫБРАТЬ ВремТабл.Организация ИЗ ВремОрганизации КАК ВремТабл)
    |				И ПериметрКонсолидации <> &ПериметрКонсолидации
    |				И ТипКонсолидации = ЗНАЧЕНИЕ(Перечисление.бит_му_ТипыКонсолидации.Консолидирующая)) КАК РегСостав
    |ГДЕ
    |	(КОНЕЦПЕРИОДА(РегСостав.ДатаОкончания, ДЕНЬ) >= &Период
    |			ИЛИ РегСостав.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1))
	|;
    |
    |////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ
	|	ВремОрганизации	
    |";
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			
			СтрокаОшибок = СтрокаОшибок + Символы.Таб + Нстр("ru = '- организация ""%1%"" уже значится консолидирующей в текущем периоде для периметра консолидации ""%2%"" %3%'") + Символы.ПС;
			ТекстПоДате = ?(Выборка.ДатаОкончания <> Дата('00010101'), 
								" до " + Формат(Выборка.ДатаОкончания, "ДЛФ=D") + " включительно", 
								"");
			СтрокаОшибок = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(
													СтрокаОшибок, 
													Выборка.Организация, 
													Выборка.ПериметрКонсолидации,
													ТекстПоДате);
			
				
		КонецЦикла;
		
	КонецЕсли;
	
	Если СтрокаОшибок <> "" Тогда
		СтрокаОшибок = НСтр("ru = 'Невозможно записать элемент по причинам:'") + Символы.ПС + СтрокаОшибок;	
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(СтрокаОшибок, Объект, , Отказ);
	КонецЕсли;
	
КонецПроцедуры // ПроверитьЗаполнениеТаблицыЗначений() 

// Процедура - завершение обработки вопроса о выполнении копирования состава периметра консолидации при открытии формы. 
// 
&НаКлиенте
Процедура ПриОткрытииЗавершение(Ответ, ИсточникКопирования) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		КопированиеСоставаПериметраКонсолидации(ИсточникКопирования);
		Оповестить("ЗаписьНовогоПериметраКонсолидации");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура КопированиеСоставаПериметраКонсолидации(ИсточникКопирования)

	Выполнено = Истина;
	
	СпрОбъект = РеквизитФормыВЗначение("Объект");
	бит_ОбщегоНазначения.ЗаписатьСправочник(СпрОбъект);
	ЗначениеВДанныеФормы(СпрОбъект, Объект);
	
	НовыйПериметр = Объект.Ссылка;
	
	// Копируем записи
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПериметрКонсолидации", ИсточникКопирования);
	Запрос.УстановитьПараметр("Период", Период);
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	&Период КАК Период,
	|	СоставПериметра.Организация,
	|	СоставПериметра.ДатаОкончания,
	|	СоставПериметра.ТипКонсолидации,
	|	СоставПериметра.ПолнаяДоляВладения,
	|	СоставПериметра.ДоляНеконтролирующихАкционеров,
	|	СоставПериметра.МетодКонсолидации,
	|	СоставПериметра.ОсуществляетКонтрольПериметра
	|ИЗ
	|	РегистрСведений.бит_му_СоставПериметровКонсолидации.СрезПоследних(&Период, 
	|									ПериметрКонсолидации = &ПериметрКонсолидации) КАК СоставПериметра
    |
	|";
	Результат = Запрос.Выполнить();	
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = СоставПериметраКонсолидации.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
	КонецЦикла;
	
	Модифицированность = Истина;

КонецПроцедуры // КопированиеСоставаПериметраКонсолидации()

#КонецОбласти

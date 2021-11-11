﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("БанковскийСчетОрганизация")
		И ЗначениеЗаполнено(Параметры.БанковскийСчетОрганизация) Тогда
		
		БанковскийСчетОрганизация = Параметры.БанковскийСчетОрганизация;
		
	КонецЕсли; 
	
	Если Параметры.Свойство("Организация")
		И ЗначениеЗаполнено(Параметры.Организация) Тогда
		
		Организация = Параметры.Организация;
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура БанковскийСчетОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	УстановитьОтборБанковскийСчет(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура БанковскийСчетОрганизацияПриемникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	УстановитьОтборБанковскийСчетПриемник(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура БанковскийСчетОрганизацияПриИзменении(Элемент)
	
	БанковскийСчетОрганизацияПриемник = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаСоздать(Команда)
	
	СоздатьДокументы();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаСоздатьИЗакрыть(Команда)
	
	СоздатьДокументы();
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СоздатьДокументы()

	Если НЕ ЗначениеЗаполнено(Сумма) Тогда
		Возврат;
	КонецЕсли; 
	
	Успех = Ложь;
	Ссылка = КомандаСоздатьНаСервере(Успех);
	
	Если НЕ Успех Тогда
	
		СтруктураСчетов = Новый Структура("БанковскийСчетОрганизация, БанковскийСчетОрганизацияПриемник"
											, БанковскийСчетОрганизация, БанковскийСчетОрганизацияПриемник); 
											
		АдресХранилищаБанкСчета = ПоместитьВоВременноеХранилище(СтруктураСчетов, Новый УникальныйИдентификатор);									
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", Ссылка);
		ПараметрыФормы.Вставить("АдресХранилищаБанкСчета", АдресХранилищаБанкСчета);
		
		ОткрытьФорму("Документ.бит_ЗаявкаНаРасходованиеСредств.ФормаОбъекта", ПараметрыФормы);
		
	Иначе	
		ЗаполнитьРасчетныйСчет(Ссылка);
		СоздатьПоступлениеДС(Ссылка);
	КонецЕсли; 

КонецПроцедуры // СоздатьДокументы()

// Процедура создает поступление денежных средств.
//
&НаСервере
Процедура СоздатьПоступлениеДС(Ссылка)

	РезСтруктура = бит_Визирование.ПолучитьСтатусОбъекта(Ссылка);
	
	Если РезСтруктура.Статус = Справочники.бит_СтатусыОбъектов.Заявка_Утверждена Тогда
	
		бит_Казначейство.СоздатьПланируемоеПоступлениеДС(РезСтруктура.Статус
														, БанковскийСчетОрганизацияПриемник
														, Ссылка);
	
	КонецЕсли; 

КонецПроцедуры // СоздатьПоступлениеДС()

// Процедура устанавливает отбор для банковского счета. 
//
&НаКлиенте
Процедура УстановитьОтборБанковскийСчет(ТекЭлемент)

	СтруктураОтбора = Новый Структура;
	Если ЗначениеЗаполнено(Организация) Тогда
	
  		СтруктураОтбора.Вставить("Владелец", Организация);
		
		// Установим параметры выбора.
		бит_ОбщегоНазначенияКлиентСервер.УстановитьПараметрыВыбораЭлемента(ТекЭлемент, СтруктураОтбора);
		
	КонецЕсли; 

КонецПроцедуры // УстановитьОтборБанковскийСчет()

// Процедура устанавливает отбор для банковского счета. 
//
&НаКлиенте
Процедура УстановитьОтборБанковскийСчетПриемник(ТекЭлемент)

	СтруктураОтбора = Новый Структура;
	Если ЗначениеЗаполнено(Организация) Тогда
	
  		СтруктураОтбора.Вставить("Владелец", Организация);
		
	КонецЕсли; 

	ВалютаБанкСчета = ПолучитьВалютуБанковскогоСчетаОрганизации();
	
  	СтруктураОтбора.Вставить("ВалютаДенежныхСредств", ВалютаБанкСчета);
	
	// Установим параметры выбора.
	бит_ОбщегоНазначенияКлиентСервер.УстановитьПараметрыВыбораЭлемента(ТекЭлемент, СтруктураОтбора);
	
КонецПроцедуры // УстановитьОтборБанковскийСчетПриемник()

// Функция получает валюту.
//
&НаСервере
Функция ПолучитьВалютуБанковскогоСчетаОрганизации()

	Возврат БанковскийСчетОрганизация.ВалютаДенежныхСредств;
	
КонецФункции // ПолучитьВалютуБанковскогоСчетаОрганизации()

// Процедура заполняет расчетный счет Платежной позиции.
//
&НаСервере
Процедура ЗаполнитьРасчетныйСчет(Ссылка)

	РезСтруктура = бит_Визирование.ПолучитьСтатусОбъекта(Ссылка);
	
	Если РезСтруктура.Статус = Справочники.бит_СтатусыОбъектов.Заявка_Рабочая
		ИЛИ РезСтруктура.Статус = Справочники.бит_СтатусыОбъектов.Заявка_Утверждена Тогда
	
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	бит_ПлатежнаяПозиция.Ссылка
		|ИЗ
		|	Документ.бит_ПлатежнаяПозиция КАК бит_ПлатежнаяПозиция
		|ГДЕ
		|	бит_ПлатежнаяПозиция.ДокументОснование = &ДокументОснование";
		
		Запрос.УстановитьПараметр("ДокументОснование", Ссылка);
		
		Результат = Запрос.Выполнить().Выгрузить();
		Если Результат.Количество()>0 Тогда
		
			ПлатежнаяПозиция = Результат[0].Ссылка;
			ПозицияОб = ПлатежнаяПозиция.ПолучитьОбъект();
			ПозицияОб.БанковскийСчетОрганизация 		= БанковскийСчетОрганизация;
			ПозицияОб.БанковскийСчетОрганизацияПриемник = БанковскийСчетОрганизацияПриемник;
			
			бит_ОбщегоНазначения.ЗаписатьПровестиДокумент(ПозицияОб, РежимЗаписиДокумента.Запись,, "Ошибки");
		
		КонецЕсли; 
	
	КонецЕсли; 

КонецПроцедуры // ЗаполнитьРасчетныйСчет()

// Процедура создание заявки на расходование ДС.
//
&НаСервере
Функция КомандаСоздатьНаСервере(ПроведениеУспешно)
	
	СтруктураЗаполнения = Новый Структура("ВидОперации, ДатаРасхода"
																, Перечисления.бит_ВидыОперацийЗаявкаНаРасходование.ПереводНаДругойСчет
																, ТекущаяДата());
	
	Заявка = Документы.бит_ЗаявкаНаРасходованиеСредств.СоздатьДокумент();
	Заявка.Заполнить(СтруктураЗаполнения);
	
	Заявка.Дата 		= ТекущаяДатаСеанса();
	Заявка.Сумма 		= Сумма;
	Заявка.СтавкаНДС 	= Перечисления.СтавкиНДС.БезНДС;
	Заявка.Организация 	= Организация;
	
	Если ЗначениеЗаполнено(БанковскийСчетОрганизация) Тогда
		Заявка.ВалютаДокумента = бит_ОбщегоНазначения.ЗначениеРеквизитаОбъекта(БанковскийСчетОрганизация, "ВалютаДенежныхСредств");
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	СоответствиеСтатей.СтатьяРасходования,
	               |	СоответствиеСтатей.СтатьяПоступления
	               |ИЗ
	               |	РегистрСведений.бит_СоответствиеСтатейПоступленияИРасходованияДС КАК СоответствиеСтатей
	               |ГДЕ
	               |	СоответствиеСтатей.ВидОперации = &ВидОперации";
	
	Запрос.УстановитьПараметр("ВидОперации", Перечисления.бит_ВидыОперацийЗаявкаНаРасходование.ПереводНаДругойСчет);
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Если Результат.Количество()>0 Тогда
	
		Заявка.СтатьяОборотов = Результат[0].СтатьяРасходования;
		
	Иначе	
		Заявка.СтатьяОборотов = Справочники.бит_СтатьиОборотов.ПустаяСсылка();
	КонецЕсли; 
	
	бит_ОбщегоНазначения.ЗаписатьПровестиДокумент(Заявка, РежимЗаписиДокумента.Запись,, "Ошибки");
	
	ПроверкаУспешна = Заявка.ПроверитьЗаполнение();
	
	Если ПроверкаУспешна Тогда
	
		ПроведениеУспешно = бит_ОбщегоНазначения.ЗаписатьПровестиДокумент(Заявка, РежимЗаписиДокумента.Проведение,, "Ошибки");
	
	КонецЕсли; 
	
	Возврат Заявка.Ссылка;
	
КонецФункции

#КонецОбласти


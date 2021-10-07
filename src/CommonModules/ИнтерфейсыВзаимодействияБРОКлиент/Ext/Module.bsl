﻿////////////////////////////////////////////////////////////////////////////////
// Модуль содержит процедуры и функции интерфейсов взаимодействия БРО
// с другими библиотеками/конфигурациями.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ЗапросВФНСНаПроверкуСведенийРаботников

// Процедура создает и записывает на диск файл(-ы) для представления в налоговую инспекцию
// запроса работодателя на проверку ИНН, ФИО, СНИЛС работающих лиц в электронной форме.
//
// Параметры:
//  СтруктураПараметров - Структура - варианты свойств:
//     Вариант 1:
//        * Организация - СправочникСсылка.Организации - организация, по работникам
//                        которой будут формироваться сведения для файла;
//        * ДатаПодписи - Дата - дата, на которую будут формироваться сведения для файла;
//        * РазмерПачки - Число - допустимое количество физических лиц в одном файле
//                        (необязательный параметр, по умолчанию допустимое количество равно 200;
//                        в случае превышения, будет записано необходимое количество файлов).
//     Вариант 2:
//        * РасчетПоСтраховымВзносам - ДокументСсылка.РегламентированныйОтчет - документ,
//                        по данным которого будут формироваться сведения для файла;
//        * РазмерПачки - Число - допустимое количество физических лиц в одном файле
//                        (необязательный параметр, по умолчанию допустимое количество равно 200;
//                        в случае превышения, будет записано необходимое количество файлов).
//
Процедура СформироватьИСохранитьНаДискФайлЗапросаВФНСНаПроверкуСведенийРаботников(СтруктураПараметров) Экспорт
	
	ПараметрыСохранения
	= ИнтерфейсыВзаимодействияБРОВызовСервера.СформироватьФайлЗапросаВФНСНаПроверкуСведенийРаботников(
	СтруктураПараметров);
	
	Если ТипЗнч(ПараметрыСохранения) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	СохранитьНаДискФайлЗапросаВФНСНаПроверкуСведенийРаботников(ПараметрыСохранения);
	
КонецПроцедуры

#КонецОбласти

#Область РучнойВводСтатусовОтправки

// Процедура предназначена для установки вручную статуса отправки из экранных форм объектов,
// отображаемых на закладке "Отчеты" формы "1С-Отчетность", путем выбора значения из выпадающего списка.
//
// Параметры:
//  ПараметрыИзменения - Структура со свойствами:
//    "Форма" - ФормаКлиентскогоПриложения - форма регл. отчета или уведомления о спецрежимах налогообложения;
//    "Организация" - СправочникСсылка.Организации - организация;
//    "КонтролирующийОрган" - Перечисление.ТипыКонтролирующихОрганов - контролирующий орган;
//    "ТекстВопроса" (необязательный) - Строка - текст предупреждения при попытке установить статус "Сдано".
//
Процедура ИзменитьСтатусОтправки(ПараметрыИзменения) Экспорт
	
	РегламентированнаяОтчетностьКлиент.ИзменитьСтатусОтправки(ПараметрыИзменения);
	
КонецПроцедуры

#КонецОбласти

#Область УведомлениеОбИзмененииОКТМО

// Показывает организациям из Московской области уведомление об изменении ОКТМО в 2018 году.
//
// Параметры:
//   Организация - СправочникСсылка.Организации - ссылка на организацию для которой нужно вывести уведомление.
//   ОповещениеПродолжения - ОписаниеОповещения - описание оповещения, вызываемого после закрытия формы.
//
Процедура ПоказатьУведомлениеОбИзмененииОКТМО46(Организация, ОповещениеПродолжения = Неопределено) Экспорт
	
	ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
	
	Если ЗначениеЗаполнено(Организация) И ТекущаяДата < '2018-04-01'
	   И ИнтерфейсыВзаимодействияБРОВызовСервера.ТребуетсяВыводУведомлениеОбИзмененииОКТМО46(Организация) Тогда
		Параметры = Новый Структура;
		Параметры.Вставить("Организация", Организация);
		
		ОткрытьФорму("Обработка.ОбщиеОбъектыРеглОтчетности.Форма.УведомлениеОбИзменениеОКТМО46",
			Параметры, , , , , ОповещениеПродолжения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
	Иначе
		Если ОповещениеПродолжения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеПродолжения);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

Процедура ЗапроситьВыпискуОперацийПоРасчетуСБюджетом(ОповещениеОЗавершении, Организация, РегистрацияВНалоговомОргане, Год) Экспорт
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
	ДополнительныеПараметры.Вставить("Организация", Организация);
	ДополнительныеПараметры.Вставить("РегистрацияВНалоговомОргане", РегистрацияВНалоговомОргане);
	ДополнительныеПараметры.Вставить("Год", Год);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗапроситьВыпискуОперацийПоРасчетуСБюджетом_Завершение", ЭтотОбъект, ДополнительныеПараметры);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗапроситьВыпискуОперацийПоРасчетуСБюджетом_Завершение(Результат, ВходящийКонтекст) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
	Если КонтекстЭДОКлиент = Неопределено Тогда
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.ТекстОшибки);
		ВыполнитьОбработкуОповещения(ВходящийКонтекст.ОповещениеОЗавершении, Неопределено);
		Возврат;
		
	КонецЕсли;
	
	КонтекстЭДОКлиент.ЗапроситьВыпискуОперацийПоРасчетуСБюджетом(ВходящийКонтекст);
	
КонецПроцедуры

#Область ЗапросВФНСНаПроверкуСведенийРаботников

Процедура СохранитьНаДискФайлЗапросаВФНСНаПроверкуСведенийРаботников(ПараметрыСохранения)
	
	Оп = Новый ОписаниеОповещения(
	"СохранитьНаДискФайлЗапросаВФНСНаПроверкуСведенийРаботниковПродолжение", ЭтотОбъект, ПараметрыСохранения);
	
	НачатьПодключениеРасширенияРаботыСФайлами(Оп);
	
КонецПроцедуры

Процедура СохранитьНаДискФайлЗапросаВФНСНаПроверкуСведенийРаботниковПродолжение(Подключено, ПараметрыСохранения) Экспорт
	
	Если НЕ Подключено Тогда
		Для каждого ОпПередаваемогоФайла Из ПараметрыСохранения.ПолучаемыеФайлы Цикл
			ПолучитьФайл(ОпПередаваемогоФайла.Хранение, ОпПередаваемогоФайла.Имя, Истина);
		КонецЦикла;
		Возврат;
	КонецЕсли;
	
	Оп = Новый ОписаниеОповещения(
	"СохранитьНаДискФайлЗапросаВФНСНаПроверкуСведенийРаботниковЗавершение", ЭтотОбъект, ПараметрыСохранения);
	
	ДиалогВыбораКаталога = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбораКаталога.Заголовок = НСтр("ru = 'Укажите каталог'");
	
	НачатьПолучениеФайлов(Оп, ПараметрыСохранения.ПолучаемыеФайлы, ДиалогВыбораКаталога, Истина);
	
КонецПроцедуры

Процедура СохранитьНаДискФайлЗапросаВФНСНаПроверкуСведенийРаботниковЗавершение(ПолученныеФайлы, ПараметрыСохранения) Экспорт
	
	Если ПолученныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПолученныеФайлы.Количество() = 1 Тогда
		
		РазделительПутиОС = ПолучитьРазделительПути();
		ПолноеИмяПолученногоФайла = СтрЗаменить(ПолученныеФайлы[0].ПолноеИмя, "/", РазделительПутиОС);
		ДанныеФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ПолноеИмяПолученногоФайла);
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр(
		"ru='Файл запроса в ФНС на проверку ИНН, ФИО, СНИЛС работающих лиц %1 сохранен в каталог %2.'"),
		ДанныеФайла.Имя, ДанныеФайла.Путь);
		Сообщение.Сообщить();
		
	ИначеЕсли ПолученныеФайлы.Количество() > 1 Тогда
		
		Сообщение = Новый СообщениеПользователю;
		ТекстСообщения = "Файлы запроса в ФНС на проверку ИНН, ФИО, СНИЛС работающих лиц:";
		Для Каждого ПолучФайл Из ПолученныеФайлы Цикл
			ДанныеФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ПолучФайл.Имя);
			ТекстСообщения = ТекстСообщения + Символы.ПС + "- """ + ДанныеФайла.Имя + """;";
		КонецЦикла;
		ТекстСообщения = ТекстСообщения + Символы.ПС + "сохранены в каталог """ + ДанныеФайла.Путь + """.";
		Сообщение.Текст = ТекстСообщения;
		Сообщение.Сообщить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
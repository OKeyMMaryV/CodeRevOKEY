﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Параметры.Сообщение) Тогда
		Отказ = Истина;
		Возврат;
	Иначе 
		Сообщение = Параметры.Сообщение;
	КонецЕсли;
	
	// инициализируем контекст ЭДО - модуль обработки
	КонтекстЭДО = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	
	// извлекаем файл документа из содержимого сообщения
	Вложения = КонтекстЭДО.ПолучитьВложенияТранспортногоСообщения(Сообщение, Истина, Перечисления.ТипыСодержимогоТранспортногоКонтейнера.СообщениеОПростОтметки, ИмяФайлаДокумента);
	Если Вложения.Количество() = 0 Тогда
		ТекстПредупреждения = "Вложения требуемого типа не обнаружено среди содержимого сообщения.";
		Возврат;
	КонецЕсли;
	Вложение = Вложения[0];
	
	// записываем вложение во временный файл
	ФайлДокумента = ПолучитьИмяВременногоФайла("xml");
	Попытка
		Вложение.Данные.Получить().Записать(ФайлДокумента);
	Исключение
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка выгрузки вложения во временный файл:
                  |%1'"), КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,, Отказ);
		Возврат;
	КонецПопытки;
	
	// считываем документ из файла в дерево XML
	ОписаниеОшибки = "";
	ДеревоXML = КонтекстЭДО.ЗагрузитьXMLВДеревоЗначений(ФайлДокумента, , ОписаниеОшибки);
	ОперацииСФайламиЭДКО.УдалитьВременныйФайл(ФайлДокумента);
	Если НЕ ЗначениеЗаполнено(ДеревоXML) Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка чтения XML из файла:
                  |%1'"), КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,, Отказ);
		Возврат;
	КонецЕсли;
	
	// анализируем XML
	УзелФайл = ДеревоXML.Строки.Найти("Файл", "Имя");
	Если НЕ ЗначениеЗаполнено(УзелФайл) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Некорректная структура XML файла: не обнаружен узел ""Файл"".'"),,,, Отказ);
		Возврат;
	КонецЕсли;
	
	// начинаем заполнять общие сведения
	ОбщиеСведения = Новый Структура;
	Для Каждого УзелСведений Из УзелФайл.Строки Цикл
		ИмяУзла = УзелСведений.Имя;
		Если ИмяУзла = "ИдФайл" ИЛИ ИмяУзла = "ВерсПрог" ИЛИ ИмяУзла = "ВерсФорм" Тогда
			ОбщиеСведения.Вставить(УзелСведений.Имя, СокрЛП(УзелСведений.Значение));
		КонецЕсли;
	КонецЦикла;
	
	УзелДокумент = УзелФайл.Строки.Найти("Документ", "Имя");
	Если НЕ ЗначениеЗаполнено(УзелДокумент) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Некорректная структура XML файла: не обнаружен узел ""Документ"".'"),,,, Отказ);
		Возврат;
	КонецЕсли;
	
	УзелСвОтметка = УзелДокумент.Строки.Найти("СвОтметка", "Имя");
	Если НЕ ЗначениеЗаполнено(УзелСвОтметка) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Некорректная структура XML файла: не обнаружен узел ""СвОтметка"".'"),,,, Отказ);
		Возврат;
	КонецЕсли;
	
	// разбираем узел с общими сведениями
	Для Каждого УзелОбщСвед Из УзелСвОтметка.Строки Цикл
		ОбщиеСведения.Вставить(УзелОбщСвед.Имя, СокрЛП(УзелОбщСвед.Значение));
	КонецЦикла;
	
	Если ОбщиеСведения.Свойство("ИдФайл") Тогда
		ИдФайл = ОбщиеСведения.ИдФайл;
	КонецЕсли;

	Если ОбщиеСведения.Свойство("ВерсПрог") Тогда
		ВерсПрог = ОбщиеСведения.ВерсПрог;
	КонецЕсли;

	Если ОбщиеСведения.Свойство("ВерсФорм") Тогда
		ВерсФорм = ОбщиеСведения.ВерсФорм;
	КонецЕсли;
	
	Если ОбщиеСведения.Свойство("НомерДокНП") Тогда
		НомерДокНП = ОбщиеСведения.НомерДокНП;
	КонецЕсли;

	Если ОбщиеСведения.Свойство("ДатаДокНП") Тогда
		ДатаДокНП = ОбщиеСведения.ДатаДокНП;
	КонецЕсли;

	Если ОбщиеСведения.Свойство("РегНомДок") Тогда
		РегНомДок = ОбщиеСведения.РегНомДок;
	КонецЕсли;
	
	Если ОбщиеСведения.Свойство("ДатаОтмПров") Тогда
		ДатаОтмПров = ОбщиеСведения.ДатаОтмПров;
	КонецЕсли;

	Если ОбщиеСведения.Свойство("ДатаСообОтм") Тогда
		ДатаСообОтм = ОбщиеСведения.ДатаСообОтм;
	КонецЕсли;
	
	Элементы.Печать.Видимость = Параметры.ПечатьВозможна;
	Если Параметры.ПечатьВозможна Тогда
		ЦиклОбмена = Параметры.ЦиклОбмена;
		ФорматДокументооборота = Параметры.ЦиклОбмена.ФорматДокументооборота;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(ТекстПредупреждения) Тогда
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбщиеСведенияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Печать(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПечатьЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПечатьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	РезультатНастройки = Новый Структура("ПечататьРезультатОбработки, ФорматДокументооборота", Истина, ФорматДокументооборота);
	КонтекстЭДОКлиент.СформироватьИПоказатьПечатныеДокументы(ЦиклОбмена, РезультатНастройки);
	
КонецПроцедуры

#КонецОбласти
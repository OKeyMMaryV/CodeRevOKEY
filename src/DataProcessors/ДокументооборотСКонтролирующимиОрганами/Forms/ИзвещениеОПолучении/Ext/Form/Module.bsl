﻿&НаСервере
Перем КонтекстЭДО;

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если ЗначениеЗаполнено(ТекстПредупреждения) Тогда 
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

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
	
	// извлекаем файл извещения из содержимого сообщения
	СтрИзвещения = КонтекстЭДО.ПолучитьВложенияТранспортногоСообщения(Сообщение, Истина, Перечисления.ТипыСодержимогоТранспортногоКонтейнера.ИзвещениеОПолучении, ИмяФайлаИзвещения);
	Если СтрИзвещения.Количество() = 0 Тогда
		ТекстПредупреждения = "Извещение о получении не обнаружено среди содержимого сообщения.";
		Возврат;
	КонецЕсли;
	СтрИзвещение = СтрИзвещения[0];
	
	// записываем вложение во временный файл
	ФайлИзвещения = ПолучитьИмяВременногоФайла("xml");
	Попытка
		СтрИзвещение.Данные.Получить().Записать(ФайлИзвещения);
	Исключение
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка выгрузки извещения о получении во временный файл:
                  |%1'"), КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,, Отказ);
		Возврат;
	КонецПопытки;
	
	// считываем извещение из файла в дерево XML
	ОписаниеОшибки = "";
	ДеревоXML = КонтекстЭДО.ЗагрузитьXMLВДеревоЗначений(ФайлИзвещения, , ОписаниеОшибки);
	ОперацииСФайламиЭДКО.УдалитьВременныйФайл(ФайлИзвещения);
	Если НЕ ЗначениеЗаполнено(ДеревоXML) Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка чтения XML из файла извещения о получении:
                  |%1'"), КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,, Отказ);
		Возврат;
	КонецЕсли;
	
	
	// анализируем XML
	УзелФайл = ДеревоXML.Строки.Найти("Файл", "Имя");
	Если НЕ ЗначениеЗаполнено(УзелФайл) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Некорректная структура XML извещения: не обнаружен узел ""Файл"".'"),,,, Отказ);
		Возврат;
	КонецЕсли;
	
	УзелДокумент = УзелФайл.Строки.Найти("Документ", "Имя");
	Если НЕ ЗначениеЗаполнено(УзелДокумент) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Некорректная структура XML извещения: не обнаружен узел ""Документ"".'"),,,, Отказ);
		Возврат;
	КонецЕсли;
	
	УзелСвИзвещП = УзелДокумент.Строки.Найти("СвИзвещП", "Имя");
	Если НЕ ЗначениеЗаполнено(УзелСвИзвещП) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Некорректная структура XML извещения: не обнаружен узел ""СвИзвещП"".'"),,,, Отказ);
		Возврат;
	КонецЕсли;
	
	// получаем сведения о дате и времени поступившего файла
	УзелДатаПол = УзелСвИзвещП.Строки.Найти("ДатаПол", "Имя");
	УзелВремяПол = УзелСвИзвещП.Строки.Найти("ВремяПол", "Имя");
	Если ЗначениеЗаполнено(УзелДатаПол) Тогда
		ДатаВремяПолучения = СокрЛП(УзелДатаПол.Значение);
	КонецЕсли;
	Если ЗначениеЗаполнено(УзелВремяПол) Тогда
		ДатаВремяПолучения = СокрЛП(ДатаВремяПолучения + " " + СокрЛП(УзелВремяПол.Значение));
	КонецЕсли;
	
	// получаем сведения о полученных файлах
	УзлыСведПолФайл = УзелСвИзвещП.Строки.НайтиСтроки(Новый Структура("Имя", "СведПолФайл"));
	Для Каждого УзелСведПолФайл Из УзлыСведПолФайл Цикл
		УзелИмяПостФайла = УзелСведПолФайл.Строки.Найти("ИмяПостФайла", "Имя");
		Если ЗначениеЗаполнено(УзелИмяПостФайла) Тогда
			НовСтр = Файлы.Добавить();
			НовСтр.ИмяФайла = СокрЛП(УзелИмяПостФайла.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Элементы.Печать.Видимость = Параметры.ПечатьВозможна;
	Если Параметры.ПечатьВозможна Тогда
		ЦиклОбмена = Параметры.ЦиклОбмена;
		ФорматДокументооборота = Параметры.ЦиклОбмена.ФорматДокументооборота;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаВремяПолученияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

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
	РезультатНастройки = Новый Структура("ПечататьИзвещенияОПолучении, ФорматДокументооборота, ТранспортноеСообщение", Истина, ФорматДокументооборота, Сообщение);
	КонтекстЭДОКлиент.СформироватьИПоказатьПечатныеДокументы(ЦиклОбмена, РезультатНастройки);
	
КонецПроцедуры

#КонецОбласти
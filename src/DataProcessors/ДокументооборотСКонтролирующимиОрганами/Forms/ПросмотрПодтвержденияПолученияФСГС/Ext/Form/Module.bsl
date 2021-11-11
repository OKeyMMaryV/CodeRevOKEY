﻿&НаСервере
Перем КонтекстЭДОСервер Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// инициализируем контекст ЭДО - модуль обработки
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	
	Заголовок = "Подтверждение получения " + Параметры.ИмяФайла;
	
	Сообщение = Параметры.Сообщение;
	
	// считываем текст из файла уведомления
	Попытка
		ПутьКФайлу = ПолучитьИмяВременногоФайла();
		ПолучитьИзВременногоХранилища(Параметры.ПодтверждениеПолучения).Записать(ПутьКФайлу);
		ЧтениеТекста = Новый ЧтениеТекста;
		КонтекстЭДОСервер.ЧтениеТекстаОткрытьНаСервере(ЧтениеТекста, ПутьКФайлу);
		СтрокаXML = ЧтениеТекста.Прочитать();
		ЧтениеТекста.Закрыть();
		ОперацииСФайламиЭДКО.УдалитьВременныйФайл(ПутьКФайлу); // xml-файл
	Исключение
		Отказ = Истина;
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Ошибка чтения содержимого подтверждения из файла: %1'"),
			Символы.ПС + Символы.ПС + ИнформацияОбОшибке().Описание);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецПопытки;
	
	// загружаем XML из строки в дерево
	ДеревоXML = КонтекстЭДОСервер.ЗагрузитьСтрокуXMLВДеревоЗначений(СтрокаXML);
	Если ДеревоXML = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	УзелИзвещение = ДеревоXML.Строки.Найти("извещение", "Имя");
	Если НЕ ЗначениеЗаполнено(УзелИзвещение) Тогда
		ТекстСообщения = НСтр("ru = 'Некорректная структура XML извещения: не обнаружен узел ""Извещение"".'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	УзелПосылка = УзелИзвещение.Строки.Найти("посылка", "Имя");
	Если НЕ ЗначениеЗаполнено(УзелПосылка) Тогда
		ТекстСообщения = НСтр("ru = 'Некорректная структура XML извещения: не обнаружен узел ""Посылка"".'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	УзелДокументы = УзелПосылка.Строки.Найти("документы", "Имя");
	Если НЕ ЗначениеЗаполнено(УзелДокументы) Тогда
		ТекстСообщения = НСтр("ru = 'Некорректная структура XML извещения: не обнаружен узел ""Документы"".'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// получаем идентификаторы поступивших файлов
	ИдентификаторыДокументов = "";
	Для каждого УзелДокумент Из УзелДокументы.Строки Цикл
		ИдентификаторДокумента = УзелДокумент.Строки.Найти("идентификаторДокумента", "Имя");
		Если ЗначениеЗаполнено(ИдентификаторДокумента) Тогда
			ИдентификаторыДокументов = ИдентификаторыДокументов + ?(ПустаяСтрока(ИдентификаторыДокументов), "", ",") + СокрЛП(ИдентификаторДокумента.Значение);
		КонецЕсли;
	КонецЦикла;
		
	ДокументыЦиклаОбмена = Неопределено;
	
	Если НЕ ПустаяСтрока(ИдентификаторыДокументов) Тогда
		
		СообщенияЦиклаОбмена = КонтекстЭДОСервер.ПолучитьСообщенияЦиклаОбмена(Сообщение.ЦиклОбмена).ВыгрузитьКолонку("Ссылка");
		
		ТипыДИВ = Новый Массив;
		ТипыДИВ.Добавить(Перечисления.ТипыСодержимогоТранспортногоКонтейнера.ПисьмоФСГС);
		ТипыДИВ.Добавить(Перечисления.ТипыСодержимогоТранспортногоКонтейнера.ПриложениеПисьмаФСГС);
		ТипыДИВ.Добавить(Перечисления.ТипыСодержимогоТранспортногоКонтейнера.ФайлОтчетностиФСГС);
		ТипыДИВ.Добавить(Перечисления.ТипыСодержимогоТранспортногоКонтейнера.УведомлениеОПриемеВОбработкуОтчетаФСГС);
		ТипыДИВ.Добавить(Перечисления.ТипыСодержимогоТранспортногоКонтейнера.УведомлениеОбУточненииОтчетаФСГС);
		ТипыДИВ.Добавить(Перечисления.ТипыСодержимогоТранспортногоКонтейнера.УведомлениеОНесоответствииФорматуОтчетаФСГС);
		ТипыДИВ.Добавить(Перечисления.ТипыСодержимогоТранспортногоКонтейнера.УведомлениеОбОтказеОтчетаФСГС);
		
		ДокументыЦиклаОбмена = КонтекстЭДОСервер.ПолучитьВложенияТранспортногоСообщения(СообщенияЦиклаОбмена,, ТипыДИВ);
		
		КоличествоДокументов = ДокументыЦиклаОбмена.Количество();
		Для Счетчик = 1 По КоличествоДокументов Цикл
			СтрокаТаблицыДокументов = ДокументыЦиклаОбмена[КоличествоДокументов - Счетчик];
			Если СтрНайти(ИдентификаторыДокументов, СокрЛП(СтрокаТаблицыДокументов.Идентификатор)) > 0 Тогда
				ИдентификаторыДокументов = СтрЗаменить(ИдентификаторыДокументов, СокрЛП(СтрокаТаблицыДокументов.Идентификатор), "");
			Иначе
				ДокументыЦиклаОбмена.Удалить(СтрокаТаблицыДокументов);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Если (ДокументыЦиклаОбмена = Неопределено) ИЛИ (ДокументыЦиклаОбмена.Количество() = 0) Тогда
	
		ТекстСообщения = НСтр("ru = 'Не обнаружены документы, указанные в извещении.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
		Возврат;
	
	КонецЕсли;
	
	// заполняем табличные поля формы
	Для каждого СтрДокумент Из ДокументыЦиклаОбмена Цикл
		
		СтрСодержимое = Содержимое.Добавить();
		СтрСодержимое.Имя                   = СтрДокумент.ИмяФайла;
		СтрСодержимое.Идентификатор         = СтрДокумент.Идентификатор;
		СтрСодержимое.ТранспортноеСообщение = СтрДокумент.ТранспортноеСообщение;
	
	КонецЦикла;
	
	ЦиклОбмена = Параметры.ЦиклОбмена;
	ФорматДокументооборота = Параметры.ЦиклОбмена.ФорматДокументооборота;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Печать(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПечатьЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СодержимоеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДополнительныеПараметры = Новый Структура("Элемент", Элемент);
	ОписаниеОповещения = Новый ОписаниеОповещения("СодержимоеВыборЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПечатьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	РезультатНастройки = Новый Структура("ПросмотрПодтвержденияПолученияФСГС, ФорматДокументооборота, ТранспортноеСообщение", Истина, ФорматДокументооборота, Сообщение);
	КонтекстЭДОКлиент.СформироватьИПоказатьПечатныеДокументы(ЦиклОбмена, РезультатНастройки);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСтрокуВложенияНаСервере(СообщениеПротокол, ИмяФайлаДокумента)
	
	Если КонтекстЭДОСервер = Неопределено Тогда 
		// инициализируем контекст ЭДО - модуль обработки
		КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	КонецЕсли;
	
	Результат = Новый Структура;
	Вложения = КонтекстЭДОСервер.ПолучитьВложенияТранспортногоСообщения(СообщениеПротокол, Истина, , ИмяФайлаДокумента);
	Если Вложения.Количество() = 0 Тогда
		Результат.Вставить("Предупреждение", "Приложение не найдено.");
		Возврат Результат;
	КонецЕсли;
	
	Вложение = Вложения[0];
	Для Каждого Колонка Из Вложения.Колонки Цикл
		Если ЗначениеЗаполнено(Вложение[Колонка.Имя]) Тогда 
			Результат.Вставить(Колонка.Имя, Вложение[Колонка.Имя]);
		КонецЕсли;
	КонецЦикла;
	
	Если Вложение.Тип = Перечисления.ТипыСодержимогоТранспортногоКонтейнера.УведомлениеОПриемеВОбработкуОтчетаФСГС
		ИЛИ Вложение.Тип = Перечисления.ТипыСодержимогоТранспортногоКонтейнера.УведомлениеОбУточненииОтчетаФСГС
		ИЛИ Вложение.Тип = Перечисления.ТипыСодержимогоТранспортногоКонтейнера.УведомлениеОНесоответствииФорматуОтчетаФСГС
		ИЛИ Вложение.Тип = Перечисления.ТипыСодержимогоТранспортногоКонтейнера.УведомлениеОбОтказеОтчетаФСГС
		ИЛИ Вложение.Тип = Перечисления.ТипыСодержимогоТранспортногоКонтейнера.ПисьмоФСГС Тогда
		
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла(Вложение.ИмяФайла);
		Вложение.Данные.Получить().Записать(ИмяВременногоФайла);
		Текст = Новый ЧтениеТекста(ИмяВременногоФайла, "windows-1251");
		ТекстВложения = Текст.Прочитать();
		Результат.Вставить("ТекстВложения", ТекстВложения);
		Результат.Вставить("ЭтоTXT", Истина);
		
	ИначеЕсли Вложение.Тип <> Перечисления.ТипыСодержимогоТранспортногоКонтейнера.ФайлОтчетностиФСГС
			И Вложение.Тип <> Перечисления.ТипыСодержимогоТранспортногоКонтейнера.ПриложениеПисьмаФСГС Тогда
		
		Результат.Вставить("ЭтоXML", Истина);
		
	Иначе
		
		ДанныеХранилища  = Вложение.Данные.Получить();
		Результат.Вставить("Данные", ДанныеХранилища);
		Результат.Вставить("Адрес", ПоместитьВоВременноеХранилище(ДанныеХранилища));
		Если НЕ Результат.Свойство("ТипСодержимогоФайла") Тогда
			Результат.Вставить("ТипСодержимогоФайла", Перечисления.ТипыСодержимогоФайлов.Неизвестный);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура СодержимоеВыборЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	Элемент = ДополнительныеПараметры.Элемент;
	ИмяФайлаДокумента = Элемент.ТекущиеДанные.Имя;
	СообщениеВладелец = Элемент.ТекущиеДанные.ТранспортноеСообщение;
	
	Вложение = ПолучитьСтрокуВложенияНаСервере(СообщениеВладелец, ИмяФайлаДокумента);

	Если КонтекстЭДОКлиент <> Неопределено Тогда
		Если Вложение.Свойство("Предупреждение") Тогда 
			ПоказатьПредупреждение(, Вложение.Предупреждение);
		Иначе
			КонтекстЭДОКлиент.ПоказатьВложениеФСГС(Вложение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


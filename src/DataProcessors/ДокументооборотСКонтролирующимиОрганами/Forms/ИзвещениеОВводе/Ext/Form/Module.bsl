﻿
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
	СтрИзвещения = КонтекстЭДО.ПолучитьВложенияТранспортногоСообщения(Сообщение, Истина, Перечисления.ТипыСодержимогоТранспортногоКонтейнера.ИзвещениеОВводе, ИмяФайлаИзвещения);
	Если СтрИзвещения.Количество() = 0 Тогда
		ТекстПредупреждения = НСтр("ru = 'Извещение о вводе не обнаружено среди содержимого сообщения.'");
		Возврат;
	КонецЕсли;
	СтрИзвещение = СтрИзвещения[0];
	
	// записываем вложение во временный файл
	ФайлИзвещения = ПолучитьИмяВременногоФайла("xml");
	Попытка
		СтрИзвещение.Данные.Получить().Записать(ФайлИзвещения);
	Исключение
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ошибка выгрузки извещения о вводе во временный файл:
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
			НСтр("ru = 'Ошибка чтения XML из файла извещения о вводе::
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
	
	УзелСвИзвещВ = УзелДокумент.Строки.Найти("СвИзвещВ", "Имя");
	Если НЕ ЗначениеЗаполнено(УзелСвИзвещВ) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Некорректная структура XML извещения: не обнаружен узел ""СвИзвещВ"".'"),,,, Отказ);
		Возврат;
	КонецЕсли;
	
	// разбираем узел с общими сведениями
	ОбщиеСведения = Новый Структура;
	Для Каждого УзелОбщСвед Из УзелСвИзвещВ.Строки Цикл
		ОбщиеСведения.Вставить(УзелОбщСвед.Имя, СокрЛП(УзелОбщСвед.Значение));
	КонецЦикла;
	
	Если ОбщиеСведения.Свойство("ИмяОбрабФайла") Тогда
		ИмяОбрабФайла = ОбщиеСведения.ИмяОбрабФайла;
	КонецЕсли;
	
	Если ОбщиеСведения.Свойство("ИдФайл") Тогда
		ИдФайл = ОбщиеСведения.ИдФайл;
	КонецЕсли;
	
	Если ОбщиеСведения.Свойство("ИдДок") Тогда
		ИдДок = ОбщиеСведения.ИдДок;
	КонецЕсли;
	
	Если ОбщиеСведения.Свойство("КНД") Тогда
		КНД = ОбщиеСведения.КНД;
	КонецЕсли;
	
	Если ОбщиеСведения.Свойство("НаимОтч") Тогда
		НаимОтч = ОбщиеСведения.НаимОтч;
	КонецЕсли;
	
	Если ОбщиеСведения.Свойство("НомКорр") Тогда
		НомКорр = ОбщиеСведения.НомКорр;
	КонецЕсли;
	
	Если ОбщиеСведения.Свойство("Период") Тогда
		ОтчетныйПериод = ОбщиеСведения.Период;
	КонецЕсли;
	
	Если ОбщиеСведения.Свойство("ПериодНаим") Тогда
		ПериодНаим = СокрЛП(ОбщиеСведения.ПериодНаим);
		Если ЗначениеЗаполнено(ОтчетныйПериод) Тогда
			ОтчетныйПериод = ОтчетныйПериод + " (" + ПериодНаим + ")";
		Иначе
			ОтчетныйПериод = ПериодНаим;
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщиеСведения.Свойство("ОтчетГод") Тогда
		ОтчетГод = ОбщиеСведения.ОтчетГод;
	КонецЕсли;
	
	// разбираем сведения о налоговом органе
	УзелКодНоОтпр = УзелДокумент.Строки.Найти("КодНоОтпр", "Имя");
	Если НЕ ЗначениеЗаполнено(УзелКодНоОтпр) Тогда
		ТекстСообщения = НСтр("ru = 'Некорректная структура XML извещения: не обнаружен узел ""КодНоОтпр"".'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,, Отказ);
		Возврат;
	КонецЕсли;
	НалоговыйОрган = СокрЛП(УзелКодНоОтпр.Значение);
	
	Элементы.Печать.Видимость = Параметры.ПечатьВозможна;
	Если Параметры.ПечатьВозможна Тогда
		ЦиклОбмена = Параметры.ЦиклОбмена;
		ФорматДокументооборота = Параметры.ЦиклОбмена.ФорматДокументооборота;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПолеВводаОчистка(Элемент, СтандартнаяОбработка)
	
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
	
	РезультатНастройки = Новый Структура("ПечататьРезультатОбработки, ФорматДокументооборота", Истина, ФорматДокументооборота);
	КонтекстЭДОКлиент.СформироватьИПоказатьПечатныеДокументы(ЦиклОбмена, РезультатНастройки);
	
КонецПроцедуры

#КонецОбласти
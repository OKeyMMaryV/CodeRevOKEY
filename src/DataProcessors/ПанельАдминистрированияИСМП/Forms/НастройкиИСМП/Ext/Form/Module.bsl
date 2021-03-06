#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗначениеКонстанты = НаборКонстант.ВестиУчетТабачнойПродукцииМОТП;
	СобытияФормИСПереопределяемый.ОтображениеПредупрежденияПриРедактировании(
		Элементы.ВестиУчетТабачнойПродукцииМОТП, ЗначениеКонстанты);
	
	ЗначениеКонстанты = НаборКонстант.ВестиУчетОбувнойПродукцииИСМП;
	СобытияФормИСПереопределяемый.ОтображениеПредупрежденияПриРедактировании(
		Элементы.ВестиУчетОбувнойПродукцииИСМП, ЗначениеКонстанты);
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьАвтоматическуюОтправкуПолучениеДанныхИСМППриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокХраненияИспользованныхКодовМаркировкиПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВестиУчетМаркировкиПродукцииМОТП(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВестиУчетОбувнойПродукцииИСМППриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролироватьСтатусыКодовМаркировкиВРозницеМОТППриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролироватьСтатусыКодовМаркировкиВРозницеИСМППриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролироватьСтатусыКодовМаркировкиПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролироватьСтатусыКодовМаркировкиИСМППриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОбязательнойМаркировкиТабачнойПродукцииМОТППриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаОбязательнойМаркировкиОбувиИСМППриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастройкаОбменаИСМП(Команда)
	
	ОткрытьФорму("ОбщаяФорма.НастройкаСертификатовДляАвтоматическогоОбменаИС",,ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОтправкуПолучениеИСМП(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьРасписаниеОтправкиПолученияИСМП", ЭтотОбъект);
	
	ОткрытьНастройкуРасписанияОбмена(ОписаниеОповещения, РасписаниеОтправкиПолученияИСМП);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьОчисткуПулаКодовМаркировкиИСМП(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьРасписаниеОчисткиПулаКодовМаркировкиИСМП", ЭтотОбъект);
	
	ОткрытьНастройкуРасписанияОбмена(ОписаниеОповещения, РасписаниеОтправкиПолученияИСМП);
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыПодключенияКСУЗ(Команда)
	
	ОткрытьФорму("РегистрСведений.НастройкиОбменаСУЗ.ФормаСписка", , ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ИзменитьРасписаниеОтправкиПолученияИСМП(РасписаниеЗадания, ДополнительныеПараметры) Экспорт
	
	Если РасписаниеЗадания = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РасписаниеОтправкиПолученияИСМП = РасписаниеЗадания;
	
	ИзменитьРасписаниеЗадания("ОтправкаПолучениеДанныхИСМП", РасписаниеОтправкиПолученияИСМП);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРасписаниеОчисткиПулаКодовМаркировкиИСМП(РасписаниеЗадания, ДополнительныеПараметры) Экспорт
	
	Если РасписаниеЗадания = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РасписаниеОчисткиПулаКодовИСМП = РасписаниеЗадания;
	
	ИзменитьРасписаниеЗадания("ОчисткаПулаКодовМаркировкиИСМП", РасписаниеОчисткиПулаКодовИСМП);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьИспользованиеЗадания(ИмяЗадания, Использование)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", ИмяЗадания);
	РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];

	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Использование", Истина И Использование);
	РегламентныеЗаданияСервер.ИзменитьЗадание(РегЗадание.УникальныйИдентификатор, ПараметрыЗадания);
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", ИмяЗадания);
	РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];
	
	Элемент = Элементы[ИмяЗадания];
	УстановитьТекстНадписиРегламентнойНастройки(РегЗадание, Элемент);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьРасписаниеЗадания(ИмяЗадания, РасписаниеРегламентногоЗадания)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", ИмяЗадания);
	РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];

	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Расписание", РасписаниеРегламентногоЗадания);
	РегламентныеЗаданияСервер.ИзменитьЗадание(РегЗадание.УникальныйИдентификатор, ПараметрыЗадания);
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", ИмяЗадания);
	РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];
	
	Элемент = Элементы[ИмяЗадания];
	УстановитьТекстНадписиРегламентнойНастройки(РегЗадание, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкуРасписанияОбмена(ОписаниеОповещения, РасписаниеРегламентногоЗадания)
	
	Если РасписаниеРегламентногоЗадания = Неопределено Тогда
		РасписаниеРегламентногоЗадания = Новый РасписаниеРегламентногоЗадания;
	КонецЕсли;
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеРегламентногоЗадания);
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНастройкиЗаданий()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", "ОтправкаПолучениеДанныхИСМП");
	ЗаданиеОтправкаПолучениеДанныхИСМП = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];
	
	РасписаниеОтправкиПолученияИСМП = ЗаданиеОтправкаПолучениеДанныхИСМП.Расписание;
	
	Элементы.ОтправкаПолучениеДанныхИСМП.Доступность = ЗаданиеОтправкаПолучениеДанныхИСМП.Использование;
	УстановитьТекстНадписиРегламентнойНастройки(ЗаданиеОтправкаПолучениеДанныхИСМП, Элементы.ОтправкаПолучениеДанныхИСМП);
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", "ОчисткаПулаКодовМаркировкиИСМП");
	ЗаданиеОчисткаПулаКодовМаркировкиИСМП = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];
	
	РасписаниеОчисткиПулаКодовИСМП = ЗаданиеОтправкаПолучениеДанныхИСМП.Расписание;
	
	Элементы.ОчисткаПулаКодовМаркировкиИСМП.Доступность = ЗаданиеОчисткаПулаКодовМаркировкиИСМП.Использование;
	УстановитьТекстНадписиРегламентнойНастройки(ЗаданиеОчисткаПулаКодовМаркировкиИСМП, Элементы.ОчисткаПулаКодовМаркировкиИСМП);
	
	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

&НаСервере
Процедура УстановитьТекстНадписиРегламентнойНастройки(Задание, Элемент)
	
	Перем ТекстРасписания, РасписаниеАктивно;
	
	ИнтеграцияИС.ПолучитьТекстЗаголовкаИРасписанияРегламентнойНастройки(Задание, ТекстРасписания, РасписаниеАктивно);
	Элемент.Заголовок = ТекстРасписания;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	Результат = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
		ОбновитьИнтерфейс = Истина;
	КонецЕсли;
	
	Если Результат <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат;
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		СобытияФормИСПереопределяемый.ОбновитьФормуНастройкиПриЗаписиПодчиненныхКонстант(ЭтотОбъект, КонстантаИмя, КонстантаЗначение);
		
	КонецЕсли;
	
	Если КонстантаИмя = "ВестиУчетТабачнойПродукцииМОТП"
		И Не КонстантаЗначение Тогда
		ИзменитьИспользованиеЗадания("ОтправкаПолучениеДанныхИСМП", Ложь);
	КонецЕсли;
	
	Если КонстантаИмя = "ИспользоватьАвтоматическуюОтправкуПолучениеДанныхИСМП" Тогда
		ИзменитьИспользованиеЗадания("ОтправкаПолучениеДанныхИСМП", НаборКонстант.ИспользоватьАвтоматическуюОтправкуПолучениеДанныхИСМП);
	КонецЕсли;
	
	Если КонстантаИмя = "СрокХраненияИспользованныхКодовМаркировки" Тогда
		ИзменитьИспользованиеЗадания("ОчисткаПулаКодовМаркировкиИСМП", НаборКонстант.СрокХраненияИспользованныхКодовМаркировки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ВестиУчетТабачнойПродукцииМОТП" Тогда
		ЗначениеКонстанты = НаборКонстант.ВестиУчетТабачнойПродукцииМОТП;
		
		СобытияФормИСПереопределяемый.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ВестиУчетТабачнойПродукцииМОТП, ЗначениеКонстанты);
		
	ИначеЕсли РеквизитПутьКДанным = "НаборКонстант.ВестиУчетОбувнойПродукцииИСМП" Тогда
		ЗначениеКонстанты = НаборКонстант.ВестиУчетОбувнойПродукцииИСМП;
		
		СобытияФормИСПереопределяемый.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ВестиУчетОбувнойПродукцииИСМП, ЗначениеКонстанты);
	КонецЕсли;
	
	ВестиУчетМаркировкиПродукцииМОТП = ПолучитьФункциональнуюОпцию("ВестиУчетТабачнойПродукцииМОТП");
	
	Элементы.ДатаОбязательнойМаркировкиТабачнойПродукцииМОТП.Доступность       = ВестиУчетМаркировкиПродукцииМОТП;
	Элементы.ИспользоватьАвтоматическуюОтправкуПолучениеДанныхИСМП.Доступность = ВестиУчетМаркировкиПродукцииМОТП;
	Элементы.ОтправкаПолучениеДанныхИСМП.Доступность                           = ВестиУчетМаркировкиПродукцииМОТП;
	Элементы.НастройкаОбменаИСМП.Доступность                                   = ВестиУчетМаркировкиПродукцииМОТП;
	Элементы.КонтролироватьСтатусыКодовМаркировкиМОТП.Доступность              = ВестиУчетМаркировкиПродукцииМОТП;
	Элементы.КонтролироватьСтатусыКодовМаркировкиВРозницеМОТП.Доступность      = ВестиУчетМаркировкиПродукцииМОТП;
	
	ВестиУчетОбувнойПродукцииИСМП = ПолучитьФункциональнуюОпцию("ВестиУчетОбувнойПродукцииИСМП");
	Элементы.КонтролироватьСтатусыКодовМаркировкиИСМП.Доступность =         ВестиУчетОбувнойПродукцииИСМП;
	Элементы.КонтролироватьСтатусыКодовМаркировкиВРозницеИСМП.Доступность = ВестиУчетОбувнойПродукцииИСМП;
	Элементы.ДатаОбязательнойМаркировкиОбувиИСМП.Доступность              = ВестиУчетОбувнойПродукцииИСМП;
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Элементы.ГруппаНастройкиРегламентногоЗадания.Видимость = Ложь;
	Иначе
		УстановитьНастройкиЗаданий();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

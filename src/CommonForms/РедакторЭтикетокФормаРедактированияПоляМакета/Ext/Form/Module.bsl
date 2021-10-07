﻿
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.Свойство("РедактированиеПоляДополнительно") Тогда
		Элементы.Тип.Доступность = Ложь;
	КонецЕсли;
	
	ШагСетки = ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ШагСетки;
	
	ОписаниеПоля = ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля;
	Верх = ОписаниеПоля.Верх;
	Лево = ОписаниеПоля.Лево;
	Низ = ОписаниеПоля.Низ;
	Право = ОписаниеПоля.Право;
	Наименование = ОписаниеПоля.Наименование;
	
	Если ОписаниеПоля.Свойство("Значение") Тогда
		Значение = ОписаниеПоля.Значение;
	КонецЕсли;
	
	Если ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.Свойство("РедактируемоеПоле") Тогда
		
		Тип = ОписаниеПоля.Тип;
		ТипЗаполнения = ОписаниеПоля.ТипЗаполнения;
		ЗначениеПоУмолчанию = ОписаниеПоля.ЗначениеПоУмолчанию;
		
		Если Тип = "Text" Тогда
			Шрифт = ОписаниеПоля.Шрифт;
			ПоложениеПоГоризонтали = ОписаниеПоля.ПоложениеПоГоризонтали;
			ПоложениеПоВертикали = ОписаниеПоля.ПоложениеПоВертикали;
			Многострочность = ОписаниеПоля.Многострочность;
			РамкаСверху = ОписаниеПоля.РамкаСверху;
			РамкаСнизу = ОписаниеПоля.РамкаСнизу;
			РамкаСправа = ОписаниеПоля.РамкаСправа;
			РамкаСлева = ОписаниеПоля.РамкаСлева;
			ТипРамки = ОписаниеПоля.ТипРамки;
			ТолщинаРамки = ОписаниеПоля.ТолщинаРамки;
			ТипШтрихкода = "EAN8";
			ПодписьШтрихкода = Ложь;
			КонтрольныйСимвол = Ложь;
			РазмерШрифта = 8;
			Формат = ОписаниеПоля.Формат;
			Ориентация = ОписаниеПоля.Ориентация;
		ИначеЕсли Тип = "Barcode" Тогда
			ТипШтрихкода = ОписаниеПоля.ТипШтрихкода;
			КонтрольныйСимвол = ОписаниеПоля.КонтрольныйСимвол;
			ПодписьШтрихкода = ОписаниеПоля.ПодписьШтрихкода;
			РазмерШрифта = ОписаниеПоля.РазмерШрифтаПодписи;
			ТолщинаРамки = 1;
			ТипРамки = "Solid";
			ПоложениеПоГоризонтали = "Left";
			ПоложениеПоВертикали = "Top";
			Ориентация = ОписаниеПоля.Ориентация;
		ИначеЕсли Тип = "Image" Тогда
			РамкаСверху = ОписаниеПоля.РамкаСверху;
			РамкаСнизу = ОписаниеПоля.РамкаСнизу;
			РамкаСправа = ОписаниеПоля.РамкаСправа;
			РамкаСлева = ОписаниеПоля.РамкаСлева;
			ТипРамки = ОписаниеПоля.ТипРамки;
			ТолщинаРамки = ОписаниеПоля.ТолщинаРамки;
			ПоложениеПоГоризонтали = "Left";
			ПоложениеПоВертикали = "Top";
			ТипШтрихкода = "EAN8";
			ПодписьШтрихкода = Ложь;
			КонтрольныйСимвол = Ложь;
			РазмерШрифта = 8;
			Ориентация = ОписаниеПоля.Ориентация;
		ИначеЕсли Тип = "UserData" Тогда
			ТолщинаРамки = 1;
			ТипРамки = "Solid";
			ПоложениеПоГоризонтали = "Left";
			ПоложениеПоВертикали = "Top";
			ТипШтрихкода = "EAN8";
			ПодписьШтрихкода = Ложь;
			КонтрольныйСимвол = Ложь;
			РазмерШрифта = 8;
			Формат = ОписаниеПоля.Формат;
		КонецЕсли;
		
	ИначеЕсли  ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.Свойство("ПовторноеРедактирование") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ОписаниеПоля);
	Иначе
		Если ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.Свойство("РедактированиеПоляДополнительно") Тогда
			Тип = "UserData";
		Иначе
			Тип = "Text";
		КонецЕсли;
		ТолщинаРамки = 1;
		ТипРамки = "Solid";
		ПоложениеПоГоризонтали = "Left";
		ПоложениеПоВертикали = "Top";
		ТипШтрихкода = "EAN13";
		ПодписьШтрихкода = Истина;
		КонтрольныйСимвол = Истина;
		РазмерШрифта = 8;
		ТипЗаполнения = "Parameter";
	КонецЕсли;
	
	УстановитьВидимостьИДоступностьПолей();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("АдресХранилищаСКД") Тогда
		АдресХранилищаСКД = Параметры.АдресХранилищаСКД;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПолеОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипПриИзменении(Элемент)
	
	УстановитьВидимостьИДоступностьПолей();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписьШтрихкодаПриИзменении(Элемент)
	
	УстановитьДоступностьСвойствПодписиШтрихкода();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипЗаполненияПриИзменении(Элемент)
	
	УстановитьВидПолейЗначений();
	УстановитьКнопкиВыбораЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьВыборЗначения(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗаполнения = "Parameter" Тогда
		
		ОповещениеПриЗавершении = Новый ОписаниеОповещения("НачатьВыборЗначенияЗавершение", ЭтотОбъект);
		ОткрытьФорму("ОбщаяФорма.РедакторЭтикетокФормаВыбораПоляСКД", Новый Структура("АдресХранилищаСКД", АдресХранилищаСКД),,,,, ОповещениеПриЗавершении);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипРамкиПриИзменении(Элемент)
	
	УстановитьДоступностьТолщиныРамки();
	
КонецПроцедуры

&НаКлиенте
Процедура ФорматНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Конструктор=Новый КонструкторФорматнойСтроки(Формат);
	Конструктор.Показать(Новый ОписаниеОповещения("ФорматНачалоВыбораЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ЛевоРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Лево + Направление*ШагСетки <= 150 Тогда
		Лево = Лево + Направление*ШагСетки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПравоРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Право + Направление*ШагСетки <= 150 Тогда
		Право = Право + Направление*ШагСетки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВерхРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Верх + Направление*ШагСетки <= 150 Тогда
		Верх = Верх + Направление*ШагСетки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НизРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Низ + Направление*ШагСетки <= 150 Тогда
		Низ = Низ + Направление*ШагСетки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КоординатаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Частное = Число(Текст)/ШагСетки;
	Если Цел(Частное) <> Частное Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипШтрихкодаПриИзменении(Элемент)
	
	Если ТипШтрихкода<>"Code39" Тогда
		КонтрольныйСимвол = Истина;
	КонецЕсли;
	
	УстановитьВидимостьФлагаНаличияКонтрольногоСимвола();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьФайл(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыборФайлаЗавершить", ЭтотОбъект);
	НачатьПомещениеФайла(ОписаниеОповещения, "", Значение, Истина, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФайлДляЗначенияПоУмолчанию(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьФайлДляЗначенияПоУмолчаниюЗавершить", ЭтотОбъект);
	НачатьПомещениеФайла(ОписаниеОповещения, "", ЗначениеПоУмолчанию, Истина, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	МассивОшибок = Неопределено;
	
	Если Не ПроверитьЗаполнениеРеквизитов(МассивОшибок) Тогда
		
		Для Каждого ТекОшибка Из МассивОшибок Цикл
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекОшибка);
			
		КонецЦикла;
		
		Возврат;
		
	КонецЕсли;
	
	СформироватьОписаниеОповещенияОЗакрытии();
	Закрыть(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьКнопкиВыбораЗначения()
	
	Элементы.ВыбратьФайл.Видимость = (Тип="Image") И (ТипЗаполнения="Constant");
	Элементы.ВыбратьФайлДляЗначенияПоУмолчанию.Видимость = (Тип="Image") И (ТипЗаполнения="Parameter");
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьФлагаНаличияКонтрольногоСимвола()
	
	Если ТипШтрихкода="Code39" Тогда
		Элементы.КонтрольныйСимвол.Видимость = Истина;
	Иначе
		Элементы.КонтрольныйСимвол.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьИДоступностьПолей()
	
	Если Тип = "Barcode" Тогда
		
		Элементы.ГруппаКоординаты.Видимость = Истина;
		Элементы.ГруппаРамка.Видимость = Ложь;
		Элементы.Шрифт.Видимость = Ложь;
		Элементы.ПоложениеПоГоризонтали.Видимость = Ложь;
		Элементы.ПоложениеПоВертикали.Видимость = Ложь;
		Элементы.Многострочность.Видимость = Ложь;
		Элементы.Ориентация.Видимость = Истина;		
		Элементы.ГруппаШтрихкод.Видимость = Истина;
		Элементы.Формат.Видимость = Ложь;
		
		УстановитьВидимостьФлагаНаличияКонтрольногоСимвола();
		
	ИначеЕсли Тип = "Text" Тогда
		Элементы.ГруппаКоординаты.Видимость = Истина;
		Элементы.ГруппаРамка.Видимость = Истина;
		Элементы.Шрифт.Видимость = Истина;
		Элементы.ПоложениеПоГоризонтали.Видимость = Истина;
		Элементы.ПоложениеПоВертикали.Видимость = Истина;
		Элементы.Многострочность.Видимость = Истина;
		Элементы.Ориентация.Видимость = Истина;
		Элементы.ГруппаШтрихкод.Видимость = Ложь;
		Элементы.Формат.Видимость = Истина;
	ИначеЕсли Тип = "Image" Тогда
		Элементы.ГруппаКоординаты.Видимость = Истина;
		Элементы.ГруппаРамка.Видимость = Истина;
		Элементы.Шрифт.Видимость = Истина;
		Элементы.ПоложениеПоГоризонтали.Видимость = Ложь;
		Элементы.ПоложениеПоВертикали.Видимость = Ложь;
		Элементы.Многострочность.Видимость = Ложь;
		Элементы.Ориентация.Видимость = Истина;
		Элементы.ГруппаШтрихкод.Видимость = Ложь;
		Элементы.Формат.Видимость = Ложь;
	Иначе
		Элементы.ГруппаКоординаты.Видимость = Ложь;
		Элементы.ГруппаРамка.Видимость = Ложь;
		Элементы.Шрифт.Видимость = Ложь;
		Элементы.ПоложениеПоГоризонтали.Видимость = Ложь;
		Элементы.ПоложениеПоВертикали.Видимость = Ложь;
		Элементы.Многострочность.Видимость = Ложь;
		Элементы.Ориентация.Видимость = Ложь;
		Элементы.ГруппаШтрихкод.Видимость = Ложь;
		Элементы.Формат.Видимость = Ложь;
	КонецЕсли;
	
	УстановитьКнопкиВыбораЗначения();
	УстановитьВидПолейЗначений();
	УстановитьДоступностьСвойствПодписиШтрихкода();
	УстановитьДоступностьТолщиныРамки();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидПолейЗначений()
	
	Элементы.Значение.СписокВыбора.Очистить();
	
	Если ТипЗаполнения="Parameter" Тогда
		ЗначениеСоответствует = Ложь;
		Элементы.Значение.РедактированиеТекста = Ложь;
		Элементы.Значение.КнопкаВыбора = Истина;
		Элементы.ЗначениеПоУмолчанию.Видимость = Истина;
	Иначе
		Элементы.Значение.РедактированиеТекста = Истина;
		Элементы.Значение.КнопкаВыбора = Ложь;
		Элементы.ЗначениеПоУмолчанию.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьСвойствПодписиШтрихкода()
	
	Элементы.РазмерШрифта.Доступность = ПодписьШтрихкода;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОписаниеОповещенияОЗакрытии()
	
	ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("Тип", Тип);
	ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("Наименование", Наименование);
	ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("Значение", Значение);
	ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("ТипЗаполнения", ТипЗаполнения);
	ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("ЗначениеПоУмолчанию", ?(ТипЗаполнения="Parameter", ЗначениеПоУмолчанию, ""));
	ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("Формат", Формат);
	
	Если Тип = "Text" Тогда
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("Верх", Верх+1);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("Лево", Лево+1);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("Низ", Низ);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("Право", Право);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("Многострочность", Многострочность);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("Шрифт", Шрифт);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("ПоложениеПоГоризонтали", ПоложениеПоГоризонтали);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("ПоложениеПоВертикали", ПоложениеПоВертикали);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("РамкаСверху", РамкаСверху);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("РамкаСнизу", РамкаСнизу);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("РамкаСправа", РамкаСправа);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("РамкаСлева", РамкаСлева);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("ТипРамки", ТипРамки);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("ТолщинаРамки", ТолщинаРамки);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("Ориентация", Ориентация);
	ИначеЕсли Тип = "Barcode" Тогда
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("Верх", Верх+1);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("Лево", Лево+1);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("Низ", Низ);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("Право", Право);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("ТипШтрихкода", ТипШтрихкода);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("КонтрольныйСимвол", КонтрольныйСимвол);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("ПодписьШтрихкода", ПодписьШтрихкода);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("РазмерШрифтаПодписи", РазмерШрифта);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("Ориентация", Ориентация);
	ИначеЕсли Тип = "Image" Тогда
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("Верх", Верх+1);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("Лево", Лево+1);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("Низ", Низ);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("Право", Право);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("РамкаСверху", РамкаСверху);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("РамкаСнизу", РамкаСнизу);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("РамкаСправа", РамкаСправа);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("РамкаСлева", РамкаСлева);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("ТипРамки", ТипРамки);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("ТолщинаРамки", ТолщинаРамки);
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.ОписаниеПоля.Вставить("Ориентация", Ориентация);		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьЗаполнениеРеквизитов(МассивОшибок)
	
	МассивОшибок = Новый Массив;
	
	// Проверка типа поля.
	Если Не ЗначениеЗаполнено(Тип) Тогда
		ТекстОшибки = НСтр("ru='Не заполнен реквизит Тип поля.'");
		МассивОшибок.Добавить(ТекстОшибки);
	КонецЕсли;
	
	// Проверка типа заполнения.
	Если Не ЗначениеЗаполнено(ТипЗаполнения) Тогда
		ТекстОшибки = НСтр("ru='Не заполнен реквизит Тип заполнения.'");
		МассивОшибок.Добавить(ТекстОшибки);
	КонецЕсли;
	
	// Проверка значения.
	Если Не ЗначениеЗаполнено(Значение) И ТипЗаполнения = "Parameter" Тогда
		ТекстОшибки = НСтр("ru='Не заполнен реквизит Значение.'");
		МассивОшибок.Добавить(ТекстОшибки);
	КонецЕсли;
	
	Если Тип <> "UserData" Тогда
		
		Если Лево>Право Тогда
			ТекстОшибки = НСтр("ru='Левая координата не может быть больше правой.'");
			МассивОшибок.Добавить(ТекстОшибки);
		КонецЕсли;
		
		Если Верх>Низ Тогда
			ТекстОшибки = НСтр("ru='Верхней координата не может быть больше нижней.'");
			МассивОшибок.Добавить(ТекстОшибки);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Тип = "Text" Тогда
		
		// Проверка ПоложениеПоГоризонтали.
		Если Не ЗначениеЗаполнено(ПоложениеПоГоризонтали) Тогда
			ТекстОшибки = НСтр("ru='Не заполнен реквизит Горизонтальное положение.'");
			МассивОшибок.Добавить(ТекстОшибки);
		КонецЕсли;
		
		// Проверка ПоложениеПоВертикали.
		Если Не ЗначениеЗаполнено(ПоложениеПоВертикали) Тогда
			ТекстОшибки = НСтр("ru='Не заполнен реквизит Вертикальное положение.'");
			МассивОшибок.Добавить(ТекстОшибки);
		КонецЕсли;
		
	ИначеЕсли Тип = "Barcode" Тогда
		
		// Проверка ТипШтрихкода.
		Если Не ЗначениеЗаполнено(ТипШтрихкода) Тогда
			ТекстОшибки = НСтр("ru='Не заполнен реквизит Тип штрихкода.'");
			МассивОшибок.Добавить(ТекстОшибки);
		КонецЕсли;
		
		// Проверка РазмерПодписи.
		Если ПодписьШтрихкода Тогда
			Если Не ЗначениеЗаполнено(РазмерШрифта) Тогда
				ТекстОшибки = НСтр("ru='Не заполнен реквизит Размер шрифта подписи.'");
				МассивОшибок.Добавить(ТекстОшибки);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Тип = "Text" ИЛИ Тип = "Image" Тогда
		
		Если РамкаСверху ИЛИ РамкаСлева ИЛИ РамкаСнизу ИЛИ РамкаСправа Тогда
			
			// Проверка ТипРамки.
			Если Не ЗначениеЗаполнено(ТипРамки) Тогда
				ТекстОшибки = НСтр("ru='Не заполнен реквизит Тип рамки.'");
				МассивОшибок.Добавить(ТекстОшибки);
			КонецЕсли;
			
			// Проверка ТолщинаРамки.
			Если Не ЗначениеЗаполнено(ТолщинаРамки) Тогда
				ТекстОшибки = НСтр("ru='Не заполнен реквизит Толщина рамки.'");
				МассивОшибок.Добавить(ТекстОшибки);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат МассивОшибок.Количество() = 0;
	
КонецФункции

&НаКлиенте
Процедура УстановитьДоступностьТолщиныРамки()
	
	Если ТипРамки = "Double" Тогда
		ТолщинаРамки = 1;
		Элементы.ТолщинаРамки.Доступность = Ложь;
	Иначе
		Элементы.ТолщинаРамки.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФорматНачалоВыбораЗавершение(Текст, ДополнительныеПараметры) Экспорт
	
	Если Текст <> Неопределено Тогда
		Формат = Текст;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьВыборЗначенияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат<>Неопределено Тогда
		Значение = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайлаЗавершить(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Не Результат Тогда
		Возврат;
	КонецЕсли;
	
	ДвоичныеДанныеКартинки = ПолучитьИзВременногоХранилища(Адрес);
	СтрокаBase64 = Base64Строка(ДвоичныеДанныеКартинки);
	СтрокаBase64 = СтрЗаменить(СтрокаBase64, Символы.ПС, "");
	Значение = СтрЗаменить(СтрокаBase64, Символы.ВК, "");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФайлДляЗначенияПоУмолчаниюЗавершить(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Не Результат Тогда
		Возврат;
	КонецЕсли;
	
	ДвоичныеДанныеКартинки = ПолучитьИзВременногоХранилища(Адрес);
	СтрокаBase64 = Base64Строка(ДвоичныеДанныеКартинки);
	СтрокаBase64 = СтрЗаменить(СтрокаBase64, Символы.ПС, "");
	ЗначениеПоУмолчанию = СтрЗаменить(СтрокаBase64, Символы.ВК, "");
	
КонецПроцедуры

#КонецОбласти
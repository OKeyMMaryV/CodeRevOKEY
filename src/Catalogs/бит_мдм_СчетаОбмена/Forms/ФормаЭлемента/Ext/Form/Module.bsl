﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаОбъектаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);
	
	
	
	// Вызов механизма защиты
		
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 	
	
	фСостояние = РегистрыСведений.бит_мдм_СостоянияОбъектов.СостояниеОбъекта(Объект.Ссылка);
	
	Если ЗначениеЗаполнено(Объект.ОписаниеОбъекта) Тогда
		
		фСсылкаИсточник    = ПланыСчетов[Объект.ОписаниеОбъекта.Имя].ПолучитьСсылку(Новый УникальныйИдентификатор(Объект.ИД));
		фИмяФормыИсточника = "ПланСчетов."+Объект.ОписаниеОбъекта.Имя+".ФормаОбъекта";
		
	КонецЕсли; 
	
	УстановитьВидимость();
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	фСостояние = РегистрыСведений.бит_мдм_СостоянияОбъектов.СостояниеОбъекта(ТекущийОбъект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ГенерироватьФорму();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если НЕ Отказ И Модифицированность Тогда
		
		ПсевдоМета = Справочники.бит_мдм_ОписанияОбъектовОбмена.ЭмулироватьМетаданные(ТекущийОбъект.ОписаниеОбъекта, "Структура");
		ПсевдоОбъект = Справочники.бит_мдм_ОписанияОбъектовОбмена.ЭмулироватьОбъектПоДаннымФормы(ЭтотОбъект, ПсевдоМета);
		
		бит_мдм_РаботаСДиалогами.СохранитьДанныеФормы(ТекущийОбъект, ПсевдоОбъект, ПсевдоМета);
		
	КонецЕсли; 
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЭтоПредопределенныйПриИзменении(Элемент)
	
	Элементы.ИмяПредопределенного.АвтоОтметкаНезаполненного = Объект.ЭтоПредопределенный;
	Если НЕ Объект.ЭтоПредопределенный Тогда
	
	  Элементы.ИмяПредопределенного.ОтметкаНезаполненного = Ложь;	
	
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаРедактироватьИсточник(Команда)
	
	Если ЗначениеЗаполнено(фСсылкаИсточник) Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", фСсылкаИсточник);
		Оповещение = Новый ОписаниеОповещения("ЗавершениеРедактированияИсточника", ЭтотОбъект);
		РежимОкна = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
		ОткрытьФорму(фИмяФормыИсточника, ПараметрыФормы,,,,,Оповещение, РежимОкна);
		
	КонецЕсли; 
	
КонецПроцедуры

// Процедура обработчик оповещения "ЗавершениеРедактированияИсточника".
// 
// Параметры:
// Результат - Произвольный
// ДополнительныеДанные - Структура.
// 
&НаКлиенте 
Процедура ЗавершениеРедактированияИсточника(Результат, ДополнительныеДанные) Экспорт

	ОповеститьОбИзменении(Объект.Ссылка);
	ЭтаФорма.Прочитать();
	
КонецПроцедуры	// ЗавершениеРедактированияИсточника

&НаКлиенте
Процедура КомандаРазрешитьРедактирование(Команда)
	
	Если Модифицированность Тогда
	
		флОК = Записать();
		
		Если НЕ флОК Тогда
		
			Возврат;
		
		КонецЕсли; 
	
	КонецЕсли; 	
	
	Элементы.ФормаКомандаРазрешитьРедактирование.Пометка = НЕ Элементы.ФормаКомандаРазрешитьРедактирование.Пометка;
	
	ЭтотОбъект.ТолькоПросмотр = НЕ Элементы.ФормаКомандаРазрешитьРедактирование.Пометка;
	Элементы.ФормаКомандаРедактироватьИсточник.Доступность = НЕ Элементы.ФормаКомандаРазрешитьРедактирование.Пометка;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость/доступность элементов формы.
// 
&НаСервере
Процедура УстановитьВидимость()

	ЭтоТекущаяБаза = ?(Объект.ВидИнформационнойБазы = Справочники.бит_мпд_ВидыИнформационныхБаз.ТекущаяИнформационнаяБаза, Истина, Ложь);
	Элементы.ИД_Внешний.Видимость = НЕ ЭтоТекущаяБаза;
	Элементы.Код_Внешний.Видимость = НЕ ЭтоТекущаяБаза;
	
	ЭтаФорма.ТолькоПросмотр =  ЭтоТекущаяБаза И ЗначениеЗаполнено(фСсылкаИсточник);
	Элементы.ФормаКомандаРедактироватьИсточник.Видимость = ЭтоТекущаяБаза И ЗначениеЗаполнено(фСсылкаИсточник);
	Элементы.ФормаКомандаРазрешитьРедактирование.Видимость = ЭтоТекущаяБаза И ЗначениеЗаполнено(фСсылкаИсточник);
	
	Элементы.ИмяПредопределенного.АвтоОтметкаНезаполненного = Объект.ЭтоПредопределенный;

КонецПроцедуры // УстановитьВидимость()

// Функция создает динамические элементы управления для отображения данных из таб. частей 
// Данные и ДанныеТабличныхЧастей.
// 
&НаСервере
Процедура ГенерироватьФорму()

	Если НЕ ЗначениеЗаполнено(Объект.ОписаниеОбъекта) Тогда
	
		  Возврат;
	
	КонецЕсли; 
	
	ПсевдоМета = Справочники.бит_мдм_ОписанияОбъектовОбмена.ЭмулироватьМетаданные(Объект.ОписаниеОбъекта);
	бит_мдм_РаботаСДиалогами.УдалитьДинамическиеЭлементы(ЭтотОбъект);
	
	Имена = Новый Структура;
	Имена.Вставить("ПоляШапки", "ГруппаДинамическеПоля");
	Имена.Вставить("Страницы","ГруппаСтраницы");
	Имена.Вставить("СтраницаПоУмолчанию", "ГруппаСтраницаОбмен");
	бит_мдм_РаботаСДиалогами.ДобавитьДинамическиеЭлементы(ЭтотОбъект, ПсевдоМета, Имена);
	
	ПсевдоОбъект = Справочники.бит_мдм_ОписанияОбъектовОбмена.ЭмулироватьОбъект(Объект, ПсевдоМета);
	бит_мдм_РаботаСДиалогами.ВосстановитьДанныеШапки(ЭтотОбъект, ПсевдоОбъект);
	бит_мдм_РаботаСДиалогами.ВосстановитьДанныеТабличныхЧастей(ЭтотОбъект, ПсевдоОбъект);
	
КонецПроцедуры // ГенерироватьФорму()

#КонецОбласти



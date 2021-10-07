﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму указанного отчета. 
//
// Параметры:
//  ФормаВладелец - ФормаКлиентскогоПриложения, Неопределено - форма, из которой открывается отчет.
//  Вариант - СправочникСсылка.ВариантыОтчетов, СправочникСсылка.ДополнительныеОтчетыИОбработки - вариант 
//            отчета, форму которого требуется открыть. Если передан тип СправочникСсылка.ДополнительныеОтчетыИОбработки, 
//            то открывается дополнительный отчет, подключенный к программе. 
//  ДополнительныеПараметры - Структура - служебный параметр, не предназначен для использования.
//
Процедура ОткрытьФормуОтчета(Знач ФормаВладелец, Знач Вариант, Знач ДополнительныеПараметры = Неопределено) Экспорт
	Тип = ТипЗнч(Вариант);
	Если Тип = Тип("Структура") Тогда
		ПараметрыОткрытия = Вариант;
	ИначеЕсли Тип = Тип("СправочникСсылка.ВариантыОтчетов") 
		Или Тип = ТипСсылкиДополнительногоОтчета() Тогда
		ПараметрыОткрытия = Новый Структура("Ключ", Вариант);
		Если ДополнительныеПараметры <> Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ПараметрыОткрытия, ДополнительныеПараметры, Истина);
		КонецЕсли;
		ОткрытьФорму("Справочник.ВариантыОтчетов.ФормаОбъекта", ПараметрыОткрытия, Неопределено, Истина);
		Возврат;
	Иначе
		ПараметрыОткрытия = Новый Структура("Ссылка, Отчет, ТипОтчета, ПолноеИмяОтчета, ИмяОтчета, КлючВарианта, КлючЗамеров");
		Если ТипЗнч(ФормаВладелец) = Тип("ФормаКлиентскогоПриложения") Тогда
			ЗаполнитьЗначенияСвойств(ПараметрыОткрытия, ФормаВладелец);
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ПараметрыОткрытия, Вариант);
	КонецЕсли;
	
	Если ДополнительныеПараметры <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ПараметрыОткрытия, ДополнительныеПараметры, Истина);
	КонецЕсли;
	
	ВариантыОтчетовКлиентСервер.ДополнитьСтруктуруКлючом(ПараметрыОткрытия, "ВыполнятьЗамеры", Ложь);
	
	ПараметрыОткрытия.ТипОтчета = ВариантыОтчетовКлиентСервер.ТипОтчетаСтрокой(ПараметрыОткрытия.ТипОтчета, ПараметрыОткрытия.Отчет);
	Если Не ЗначениеЗаполнено(ПараметрыОткрытия.ТипОтчета) Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не определен тип отчета в %1'"), "ВариантыОтчетовКлиент.ОткрытьФормуОтчета");
	КонецЕсли;
	
	Если ПараметрыОткрытия.ТипОтчета = "Внутренний" Или ПараметрыОткрытия.ТипОтчета = "Расширение" Тогда
		Вид = "Отчет";
		КлючЗамеров = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыОткрытия, "КлючЗамеров");
		Если ЗначениеЗаполнено(КлючЗамеров) Тогда
			ПараметрыКлиента = ПараметрыКлиента();
			Если ПараметрыКлиента.ВыполнятьЗамеры Тогда
				ПараметрыОткрытия.ВыполнятьЗамеры = Истина;
				ПараметрыОткрытия.Вставить("ИмяОперации", КлючЗамеров + ".Открытие");
				ПараметрыОткрытия.Вставить("КомментарийОперации", ПараметрыКлиента.ПрефиксЗамеров);
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ПараметрыОткрытия.ТипОтчета = "Дополнительный" Тогда
		Вид = "ВнешнийОтчет";
		Если Не ПараметрыОткрытия.Свойство("Подключен") Тогда
			ВариантыОтчетовВызовСервера.ПриПодключенииОтчета(ПараметрыОткрытия);
		КонецЕсли;
		Если Не ПараметрыОткрытия.Подключен Тогда
			Возврат;
		КонецЕсли;
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Вариант внешнего отчета можно открыть только из формы отчета.'"));
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПараметрыОткрытия.ИмяОтчета) Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не определено имя отчета в %1'"), "ВариантыОтчетовКлиент.ОткрытьФормуОтчета");
	КонецЕсли;
	
	ПолноеИмяОтчета = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыОткрытия, "ПолноеИмяОтчета");
	
	Если Не ЗначениеЗаполнено(ПолноеИмяОтчета) Тогда 
		ПолноеИмяОтчета = Вид + "." + ПараметрыОткрытия.ИмяОтчета;
	КонецЕсли;
	
	КлючУникальности = ОтчетыКлиентСервер.КлючУникальности(ПолноеИмяОтчета, ПараметрыОткрытия.КлючВарианта);
	ПараметрыОткрытия.Вставить("КлючПараметровПечати",        КлючУникальности);
	ПараметрыОткрытия.Вставить("КлючСохраненияПоложенияОкна", КлючУникальности);
	
	Если ПараметрыОткрытия.ВыполнятьЗамеры Тогда
		ВариантыОтчетовКлиентСервер.ДополнитьСтруктуруКлючом(ПараметрыОткрытия, "КомментарийОперации");
		МодульОценкаПроизводительностиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОценкаПроизводительностиКлиент");
		ИдентификаторЗамера = МодульОценкаПроизводительностиКлиент.ЗамерВремени(
			ПараметрыОткрытия.ИмяОперации,,
			Ложь);
		МодульОценкаПроизводительностиКлиент.УстановитьКомментарийЗамера(ИдентификаторЗамера, ПараметрыОткрытия.КомментарийОперации);
	КонецЕсли;
	
	ОткрытьФорму(ПолноеИмяОтчета + ".Форма", ПараметрыОткрытия, Неопределено, Истина);
	
	Если ПараметрыОткрытия.ВыполнятьЗамеры Тогда
		МодульОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(ИдентификаторЗамера);
	КонецЕсли;
КонецПроцедуры

// Открывает панель отчетов. Для использования из модулей общих команд.
//
// Параметры:
//  ПутьКПодсистеме - Строка - имя раздела или путь к подсистеме, для которой открывается панель отчетов.
//                    Задается в формате: "ИмяРаздела[.ИмяВложеннойПодсистемы1][.ИмяВложеннойПодсистемы2][...]".
//                    Раздел должен быть описан в ВариантыОтчетовПереопределяемый.ОпределитьРазделыСВариантамиОтчетов.
//  ПараметрыВыполненияКоманды - ПараметрыВыполненияКоманды - параметры обработчика общей команды.
//
Процедура ПоказатьПанельОтчетов(ПутьКПодсистеме, ПараметрыВыполненияКоманды) Экспорт
	ФормаПараметры = Новый Структура("ПутьКПодсистеме", ПутьКПодсистеме);
	
	ФормаОкно = ?(ПараметрыВыполненияКоманды = Неопределено, Неопределено, ПараметрыВыполненияКоманды.Окно);
	ФормаСсылка = ?(ПараметрыВыполненияКоманды = Неопределено, Неопределено, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
	ПараметрыКлиента = ПараметрыКлиента();
	Если ПараметрыКлиента.ВыполнятьЗамеры Тогда
		МодульОценкаПроизводительностиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОценкаПроизводительностиКлиент");
		ИдентификаторЗамера = МодульОценкаПроизводительностиКлиент.ЗамерВремени(
			"ПанельОтчетов.Открытие",,
			Ложь);
		МодульОценкаПроизводительностиКлиент.УстановитьКомментарийЗамера(ИдентификаторЗамера, ПараметрыКлиента.ПрефиксЗамеров + "; " + ПутьКПодсистеме);
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.ПанельОтчетов", ФормаПараметры, , ПутьКПодсистеме, ФормаОкно, ФормаСсылка);
	
	Если ПараметрыКлиента.ВыполнятьЗамеры Тогда
		МодульОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(ИдентификаторЗамера);
	КонецЕсли;
КонецПроцедуры

// Оповещает открытые панели отчетов, формы списков и элементов о изменениях.
//
// Параметры:
//  Параметр - Произвольный - могут быть переданы любые необходимые данные.
//  Источник - Произвольный - источник события. Например, можно передать другую форму.
//
Процедура ОбновитьОткрытыеФормы(Параметр = Неопределено, Источник = Неопределено) Экспорт
	
	Оповестить(ИмяСобытияИзменениеВарианта(), Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// См. ОбщегоНазначенияКлиентПереопределяемый.ПриНачалеРаботыСистемы.
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт 
	
	Если Не СистемаВзаимодействия.ИспользованиеДоступно() Тогда
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ОбработатьДействияСообщения", ВариантыОтчетовКлиент);
	СистемаВзаимодействия.ПодключитьОбработчикДействияСообщения(Обработчик);
	
КонецПроцедуры

// Открывает карточку варианта отчета с настройками размещения в программе.
//
// Параметры:
//  Вариант - СправочникСсылка.ВариантыОтчетов - Ссылка варианта отчета.
//
Процедура ПоказатьНастройкиОтчета(Вариант) Экспорт
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПоказатьКарточку", Истина);
	ПараметрыФормы.Вставить("Ключ", Вариант);
	ОткрытьФорму("Справочник.ВариантыОтчетов.ФормаОбъекта", ПараметрыФормы);
КонецПроцедуры

// Открывает диалог настройки размещения нескольких вариантов в разделах.
//
// Параметры:
//   Варианты - Массив - перемещаемые варианты отчетов (СправочникСсылка.ВариантыОтчетов).
//   Владелец - ФормаКлиентскогоПриложения - для блокирования окна владельца.
//
Процедура ОткрытьДиалогРазмещенияВариантовВРазделах(Варианты, Владелец = Неопределено) Экспорт
	
	Если ТипЗнч(Варианты) <> Тип("Массив") Или Варианты.Количество() < 1 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите варианты отчетов, которые необходимо разместить в разделах.'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("Варианты", Варианты);
	ОткрытьФорму("Справочник.ВариантыОтчетов.Форма.РазмещениеВРазделах", ПараметрыОткрытия, Владелец);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбработатьДействияСообщения(Сообщение, Действие, ДополнительныеПараметры) Экспорт 
	
	Если Действие = ВариантыОтчетовКлиентСервер.ИмяДействияПрименитьПереданныеНастройки() Тогда 
		Оповестить(Действие, Сообщение.Данные);
	КонецЕсли;
	
КонецПроцедуры

// Процедура обслуживает событие реквизита ДеревоПодсистем в формах редактирования.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма, в которой редактируется дерево подсистем, где:
//       * Элементы - ВсеЭлементыФормы - см. Синтакс-помощник.
//   Элемент - ПолеФормы - поле признака использования.
//
Процедура ДеревоПодсистемИспользованиеПриИзменении(Форма, Элемент) Экспорт
	СтрокаДерева = Форма.Элементы.ДеревоПодсистем.ТекущиеДанные;
	Если СтрокаДерева = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Пропуск корневой строки
	Если СтрокаДерева.Приоритет = "" Тогда
		СтрокаДерева.Использование = 0;
		Возврат;
	КонецЕсли;
	
	Если СтрокаДерева.Использование = 2 Тогда
		СтрокаДерева.Использование = 0;
	КонецЕсли;
	
	СтрокаДерева.Модифицированность = Истина;
КонецПроцедуры

// Процедура обслуживает событие реквизита ДеревоПодсистем в формах редактирования.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма, в которой редактируется дерево подсистем, где:
//       * Элементы - ВсеЭлементыФормы - коллекция элементов формы, где:
//             ** ДеревоПодсистем - ТаблицаФормы - иерархическая коллекция подсистем, в которых отображается отчет, где:
//                   *** СтрокаДерева - ДанныеФормыЭлементДерева - данные текущей строки дерева подсистем, где:
//                           **** Важность - Строка - степени важности, принимающее значение - "", "Важный", "См. также".
//                           **** Приоритет - Строка - код-счетчик.
//                           **** Использование - Число - признак размещения отчета в данной подсистеме.
//   Элемент - ПолеФормы - поле для редактирования признака важности.
//
Процедура ДеревоПодсистемВажностьПриИзменении(Форма, Элемент) Экспорт
	
	ДеревоПодсистем = Форма.Элементы.ДеревоПодсистем;
	
	СтрокаДерева = ДеревоПодсистем.ТекущиеДанные;
	Если СтрокаДерева = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Пропуск корневой строки
	Если СтрокаДерева.Приоритет = "" Тогда
		СтрокаДерева.Важность = "";
		Возврат;
	КонецЕсли;
	
	Если СтрокаДерева.Важность <> "" Тогда
		СтрокаДерева.Использование = 1;
	КонецЕсли;
	
	СтрокаДерева.Модифицированность = Истина;
КонецПроцедуры

Функция ПараметрыКлиента()
	Возврат ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
		СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске(),
		"ВариантыОтчетов");
КонецФункции

// Имя события оповещения для изменения варианта отчета.
Функция ИмяСобытияИзменениеВарианта() Экспорт
	Возврат "Запись_ВариантыОтчетов";
КонецФункции

// Имя события оповещения для изменения общих настроек.
Функция ИмяСобытияИзменениеОбщихНастроек() Экспорт
	Возврат ВариантыОтчетовКлиентСервер.ПолноеИмяПодсистемы() + ".ИзменениеОбщихНастроек";
КонецФункции

// Возвращает тип ссылки дополнительного отчета.
Функция ТипСсылкиДополнительногоОтчета()
	Существует = ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки");
	Если Существует Тогда
		Возврат Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки");
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики списка пользователей варианта отчета

#Область ПараметрыПодбораПользователейВариантаОтчета

// Открывает форму выбора пользователей или групп (внешних) пользователей.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма, в которой редактируется дерево подсистем, где:
//       * Элементы - ВсеЭлементыФормы - коллекция элементов формы.
//   ПодборГруппВнешнихПользователей - Булево - признак подбора групп внешних пользователей.
//
Процедура ПодобратьПользователейВариантаОтчета(Форма, ПодборГруппВнешнихПользователей = Ложь) Экспорт 
	
	ПараметрыПодбора = ПараметрыПодбораПользователейВариантаОтчета(Форма, ПодборГруппВнешнихПользователей);
	
	Если ПодборГруппВнешнихПользователей Тогда 
		
		ИмяФормыПодбора = "Справочник.ГруппыВнешнихПользователей.ФормаВыбора";
		
	Иначе
		
		ИмяФормыПодбора = "Справочник.Пользователи.ФормаВыбора";
		
	КонецЕсли;
	
	ОткрытьФорму(ИмяФормыПодбора, ПараметрыПодбора, Форма.Элементы.ПользователиВарианта);
	
КонецПроцедуры

// Конструктор параметров подбора пользователей варианта отчета.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма, в которой редактируется дерево подсистем, где:
//       * Элементы - ВсеЭлементыФормы - коллекция элементов формы.
//   ПодборГруппВнешнихПользователей - Булево - признак подбора групп внешних пользователей.
//
// Возвращаемое значение:
//   Структура - параметры открытия формы подбора, где:
//       * РежимВыбора - Булево - признак режима выбора  (см. Синтакс-помощник - Расширение справочника).
//       * ТекущаяСтрока - СправочникСсылка.Пользователи,
//                         СправочникСсылка.ГруппыПользователей,
//                         СправочникСсылка.ГруппыВнешнихПользователей,
//                         Неопределено - текущий пользователь или группа (внешних) пользователей.
//       * ЗакрыватьПриВыборе - Булево - признак необходимости закрытия формы выбора (см. Синтакс-помощник - Расширение справочника).
//       * МножественныйВыбор - Булево - признак выбора двух строк и более.
//       * РасширенныйПодбор - Булево - признак использования расширенных параметров подбора.
//       * ЗаголовокФормыПодбора - Строка - заголовок формы подбора, соответствующий контексту.
//       * ВыбранныеПользователи - СписокЗначений - коллекция выбранных пользователей или групп (внешних) пользователей.
//
Функция ПараметрыПодбораПользователейВариантаОтчета(Форма, ПодборГруппВнешнихПользователей = Ложь)
	
	ТекущиеДанные = Форма.Элементы.ПользователиВарианта.ТекущиеДанные;
	ВыбранныеПользователи = ВыбранныеПользователиВарианта(Форма.ПользователиВарианта, ПодборГруппВнешнихПользователей);
	
	ПараметрыПодбора = Новый Структура;
	ПараметрыПодбора.Вставить("РежимВыбора", Истина);
	ПараметрыПодбора.Вставить("ТекущаяСтрока", ?(ТекущиеДанные = Неопределено, Неопределено, ТекущиеДанные.Значение));
	ПараметрыПодбора.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыПодбора.Вставить("МножественныйВыбор", Истина);
	ПараметрыПодбора.Вставить("РасширенныйПодбор", Истина);
	ПараметрыПодбора.Вставить("ЗаголовокФормыПодбора", НСтр("ru = 'Подбор пользователей варианта отчета'"));
	ПараметрыПодбора.Вставить("ВыбранныеПользователи", ВыбранныеПользователи);
	
	Возврат ПараметрыПодбора;
	
КонецФункции

Функция ВыбранныеПользователиВарианта(ПользователиВарианта, ПодборГруппВнешнихПользователей)
	
	ТипыВыбранныхПользователей = Новый ОписаниеТипов(
		"СправочникСсылка.ГруппыПользователей, СправочникСсылка.Пользователи");
	
	Если ПодборГруппВнешнихПользователей Тогда 
		ТипыВыбранныхПользователей = Новый ОписаниеТипов("СправочникСсылка.ГруппыВнешнихПользователей");
	КонецЕсли;
	
	ВыбранныеПользователи = Новый Массив;
	
	Для Каждого ЭлементСписка Из ПользователиВарианта Цикл 
		
		Если ЭлементСписка.Пометка
			И ТипыВыбранныхПользователей.СодержитТип(ТипЗнч(ЭлементСписка.Значение)) Тогда 
			
			ВыбранныеПользователи.Добавить(ЭлементСписка.Значение);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ВыбранныеПользователи.Количество() = 1
		И ВыбранныеПользователи[0] = Неопределено Тогда 
		
		Если ПодборГруппВнешнихПользователей Тогда 
			ВыбранныеПользователи[0] = ПредопределенноеЗначение("Справочник.ГруппыВнешнихПользователей.ВсеВнешниеПользователи");
		Иначе
			ВыбранныеПользователи[0] = ПредопределенноеЗначение("Справочник.ГруппыПользователей.ВсеПользователи");
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ВыбранныеПользователи;
	
КонецФункции

#КонецОбласти

#Область ОбработкаВыбораПользователейВариантаОтчета

Процедура ПользователиВариантаОтчетаОбработкаВыбора(Форма, ВыбранныеЗначения, СтандартнаяОбработка) Экспорт 
	
	Если ТипЗнч(ВыбранныеЗначения) <> Тип("Массив")
		Или ВыбранныеЗначения.Количество() = 0 Тогда 
		
		Возврат;
		
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ПользователиВарианта = Форма.ПользователиВарианта;
	
	ОбщаяГруппаПользователей = ПредопределенноеЗначение("Справочник.ГруппыПользователей.ВсеПользователи");
	ОбщаяГруппаВнешниеПользователи = ПредопределенноеЗначение("Справочник.ГруппыВнешнихПользователей.ВсеВнешниеПользователи");
	
	Если ТипЗнч(ВыбранныеЗначения[0]) = Тип("СправочникСсылка.ГруппыВнешнихПользователей") Тогда 
		
		ПодготовитьСписокКДобавлениюВнешнихПользователейВариантаОтчета(
			ПользователиВарианта, ВыбранныеЗначения, ОбщаяГруппаВнешниеПользователи);
		
	Иначе
		
		ПодготовитьСписокКДобавлениюПользователейВариантаОтчета(
			ПользователиВарианта, ВыбранныеЗначения, ОбщаяГруппаПользователей);
		
	КонецЕсли;
	
	Для Каждого Значение Из ВыбранныеЗначения Цикл 
		
		Если ПользователиВарианта.НайтиПоЗначению(Значение) = Неопределено Тогда 
			ПользователиВарианта.Добавить(Значение,, Истина, КартинкаПользователяВариантаОтчета(Значение));
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПользователиВарианта.НайтиПоЗначению(ОбщаяГруппаПользователей) <> Неопределено
		И ПользователиВарианта.НайтиПоЗначению(ОбщаяГруппаВнешниеПользователи) <> Неопределено Тогда 
		
		ПользователиВарианта.Очистить();
		ПользователиВарианта.Добавить(,, Истина, КартинкаПользователяВариантаОтчета());
		
	КонецЕсли;
	
	ОформитьПользователейВариантаОтчета(Форма);
	
КонецПроцедуры

Процедура ПодготовитьСписокКДобавлениюПользователейВариантаОтчета(ПользователиВарианта, ВыбранныеЗначения, ОбщаяГруппаПользователей)
	
	Если ПользователиВарианта.НайтиПоЗначению(Неопределено) <> Неопределено Тогда 
		
		ПользователиВарианта.Очистить();
		
	Иначе
		
		ТипыПользователей = Новый ОписаниеТипов("СправочникСсылка.ГруппыПользователей, СправочникСсылка.Пользователи");
		УдалитьПользователейВариантаОтчетаУказанныхТипов(ПользователиВарианта, ТипыПользователей);
		
	КонецЕсли;
	
	Если ВыбранныеЗначения.Найти(ОбщаяГруппаПользователей) = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ВыбранныеЗначения.Очистить();
	ВыбранныеЗначения.Добавить(ОбщаяГруппаПользователей);
	
КонецПроцедуры

Процедура ПодготовитьСписокКДобавлениюВнешнихПользователейВариантаОтчета(ПользователиВарианта, ВыбранныеЗначения, ОбщаяГруппаПользователей)
	
	Если ПользователиВарианта.НайтиПоЗначению(ОбщаяГруппаПользователей) <> Неопределено
		Или ПользователиВарианта.НайтиПоЗначению(Неопределено) <> Неопределено Тогда 
		
		ВыбранныеЗначения.Очистить();
		Возврат;
		
	КонецЕсли;
	
	Если ВыбранныеЗначения.Найти(ОбщаяГруппаПользователей) = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ТипыПользователей = Новый ОписаниеТипов("СправочникСсылка.ГруппыВнешнихПользователей");
	УдалитьПользователейВариантаОтчетаУказанныхТипов(ПользователиВарианта, ТипыПользователей);
	
	ВыбранныеЗначения.Очистить();
	ВыбранныеЗначения.Добавить(ОбщаяГруппаПользователей);
	
КонецПроцедуры

Процедура УдалитьПользователейВариантаОтчетаУказанныхТипов(ПользователиВарианта, ТипыПользователей)
	
	ИндексЭлемента = ПользователиВарианта.Количество() - 1;
	
	Пока ИндексЭлемента >= 0 Цикл 
		
		ЭлементСписка = ПользователиВарианта[ИндексЭлемента];
		
		Если ТипыПользователей.СодержитТип(ТипЗнч(ЭлементСписка.Значение)) Тогда 
			
			ПользователиВарианта.Удалить(ЭлементСписка);
			
		КонецЕсли;
		
		ИндексЭлемента = ИндексЭлемента - 1;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ПользователиВариантаОтчетаПрочее

Функция КартинкаПользователяВариантаОтчета(Пользователь = Неопределено)
	
	Если ТипЗнч(Пользователь) = Тип("СправочникСсылка.Пользователи") Тогда 
		
		Возврат БиблиотекаКартинок.СостояниеПользователя02;
		
	ИначеЕсли ТипЗнч(Пользователь) = Тип("СправочникСсылка.ГруппыВнешнихПользователей") Тогда 
		
		Возврат БиблиотекаКартинок.СостояниеПользователя10;
		
	КонецЕсли;
	
	Возврат БиблиотекаКартинок.СостояниеПользователя04;
	
КонецФункции

// Процедура обслуживает событие реквизита ДеревоПодсистем в формах редактирования.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма, в которой редактируется дерево подсистем, где:
//       * Элементы - ВсеЭлементыФормы - коллекция элементов формы, где:
//             ** ПользователиВарианта - ТаблицаФормы - список пользователей варианта отчета.
//   СбрасыватьПризнакИспользования - Булево - признак необходимости выключения использования.
//
Процедура ОформитьПользователейВариантаОтчета(Форма, СбрасыватьПризнакИспользования = Истина) Экспорт 
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента();
	ЦветНеактивныхЗначений = ПараметрыКлиента.ЭлементыСтиля.ТекстЗапрещеннойЯчейкиЦвет;
	
	Если Не СбрасыватьПризнакИспользования Тогда 
		
		Элементы.ПользователиВарианта.ЦветТекста = ?(Объект.ТолькоДляАвтора, ЦветНеактивныхЗначений, Новый Цвет);
		Возврат;
		
	КонецЕсли;
	
	КоличествоПомеченных = 0;
	
	Для Каждого Строка Из Форма.ПользователиВарианта Цикл 
		
		КоличествоПомеченных = КоличествоПомеченных + Булево(Строка.Пометка);
		
	КонецЦикла;
	
	Объект.ТолькоДляАвтора = (КоличествоПомеченных = 0);
	Форма.Доступен = ?(Объект.ТолькоДляАвтора, "ТолькоДляАвтора", "УказаннымПользователям");
	
	Элементы.ПользователиВарианта.ЦветТекста = ?(Форма.Объект.ТолькоДляАвтора, ЦветНеактивныхЗначений, Новый Цвет);
	
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// Обмен настройками вариантов отчетов

#Область ОбновлениеВариантаОтчетаИзФайла

Процедура ОбновитьВариантОтчетаИзФайла(ОписаниеФайла, СвойстваВариантаОтчетаОснования) Экспорт 
	
	Если ОписаниеФайла = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СвойстваВариантаОтчетаОснования = Неопределено Тогда 
		СвойстваВариантаОтчетаОснования = СвойстваВариантаОтчетаОснования();
	КонецЕсли;
	
	СвойстваВариантОтчета = ВариантыОтчетовВызовСервера.СвойстваВариантОтчетаИзФайла(
		ОписаниеФайла, СвойстваВариантаОтчетаОснования.Ссылка);
	
	Если СвойстваВариантаОтчетаОснования.ИмяОтчета = СвойстваВариантОтчета.ИмяОтчета Тогда 
		
		ПараметрыОбновленияФормы = Новый Структура("КлючВарианта");
		ЗаполнитьЗначенияСвойств(ПараметрыОбновленияФормы, СвойстваВариантОтчета);
		
		ОбновитьОткрытыеФормы(ПараметрыОбновленияФормы);
		ПоказатьОповещениеПользователя(НСтр("ru = 'Вариант отчета обновлен из файла'"));
		
	ИначеЕсли СвойстваВариантаОтчетаОснования.ПредставлениеВарианта = СвойстваВариантОтчета.ПредставлениеВарианта Тогда 
		
		ОткрытьФормуОтчета(Неопределено, СвойстваВариантОтчета.Ссылка);
		ПоказатьОповещениеПользователя(НСтр("ru = 'Вариант отчета найден и обновлен из файла'"));
		
	Иначе
		
		Обработчик = Новый ОписаниеОповещения(
			"ОткрытьФормуВыбранногоВариантаОтчета", ВариантыОтчетовКлиент, СвойстваВариантОтчета.Ссылка);
		
		ШаблонТекстаВопроса = НСтр("ru = 'Выбраны настройки варианта отчета ""%1"",
			|которые не совпадают с ""%2"".
			|Замена настроек выбранного варианта отчета невозможна.
			|
			|Создать новый вариант отчета (или обновить существующий при наличии)?'");
		
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонТекстаВопроса,
			СвойстваВариантОтчета.ПредставлениеВарианта,
			СвойстваВариантаОтчетаОснования.ПредставлениеВарианта);
		
		ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Да);
		
	КонецЕсли;
	
КонецПроцедуры

// Конструктор описания свойств варианта отчета.
//
// Возвращаемое значение:
//   Структура - где:
//     * Ссылка - СправочникСсылка.ВариантыОтчетов - 
//     * ИмяОтчета - Строка - 
//     * ПредставлениеВарианта - Строка - 
//
Функция СвойстваВариантаОтчетаОснования() Экспорт 
	
	Возврат Новый Структура("Ссылка, ИмяОтчета, ПредставлениеВарианта");
	
КонецФункции

// Обработчик оповещения.
//
// Параметры:
//   Ответ - КодВозвратаДиалога - 
//   ВариантОтчета - СправочникСсылка.ВариантыОтчетов - 
//
Процедура ОткрытьФормуВыбранногоВариантаОтчета(Ответ, ВариантОтчета) Экспорт 
	
	Если Ответ = КодВозвратаДиалога.Да Тогда 
		ОткрытьФормуОтчета(Неопределено, ВариантОтчета);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбменПользовательскимиНастройками

// Открывает форму выбора пользователей, (групп) пользователей.
//
// Параметры:
//  ОписаниеНастроек - Структура - параметры открытия формы выбора пользователей, (групп) пользователей, где:
//      * Настройки - ПользовательскиеНастройкиКомпоновкиДанных - настройки, которыми обмениваются.
//      * ВариантОтчета - СправочникСсылка.ВариантыОтчетов - ссылка на хранилище свойств варианта отчета.
//      * КлючОбъекта - Строка - измерение хранения настроек.
//      * КлючНастроек - Строка - измерение - идентификатор пользовательских настроек.
//      * Представление - Строка - наименование пользовательских настроек.
//      * ВариантМодифицирован - Булево - признак того, что вариант отчета изменен.
//
Процедура ПоделитьсяПользовательскимиНастройками(ОписаниеНастроек) Экспорт 
	
	Если ОписаниеНастроек.Настройки.Элементы.Количество() = 0 Тогда 
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Настройки (пользовательские) не установлены.'"));
		Возврат;
		
	КонецЕсли;
	
	ПараметрыПодбора = Новый Структура;
	ПараметрыПодбора.Вставить("РежимВыбора", Истина);
	ПараметрыПодбора.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыПодбора.Вставить("МножественныйВыбор", Истина);
	ПараметрыПодбора.Вставить("РасширенныйПодбор", Истина);
	ПараметрыПодбора.Вставить("СкрытьПользователейБезПользователяИБ", Истина);
	ПараметрыПодбора.Вставить("ВыбранныеПользователи", Новый Массив);
	ПараметрыПодбора.Вставить("ЗаголовокФормыПодбора", НСтр("ru = 'Поделиться настройками отчета с пользователями'"));
	ПараметрыПодбора.Вставить("ЗаголовокКнопкиЗавершенияПодбора", НСтр("ru = 'Поделиться'"));
	
	Обработчик = Новый ОписаниеОповещения(
		"ПоделитьсяПользовательскимиНастройкамиПослеВыбораПользователей", ВариантыОтчетовКлиент, ОписаниеНастроек);
	
	ОткрытьФорму("Справочник.Пользователи.ФормаВыбора", ПараметрыПодбора,,,,, Обработчик);
	
КонецПроцедуры

Процедура ПоделитьсяПользовательскимиНастройкамиПослеВыбораПользователей(ВыбранныеПользователи, ОписаниеНастроек) Экспорт 
	
	Если ВыбранныеПользователи = Неопределено
		Или ВыбранныеПользователи.Количество() = 0 Тогда 
		
		Возврат;
	КонецЕсли;
	
	ВариантыОтчетовВызовСервера.ПоделитьсяПользовательскимиНастройками(ВыбранныеПользователи, ОписаниеНастроек);
	
	Предупреждение = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ОписаниеНастроек, "Предупреждение");
	
	Если ЗначениеЗаполнено(Предупреждение) Тогда 
		
		ПоказатьПредупреждение(, Предупреждение);
		Возврат;
		
	КонецЕсли;
	
	Пояснение = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ОписаниеНастроек, "Пояснение", "");
	ПоказатьОповещениеПользователя(НСтр("ru = 'Настройки переданы'"),, Пояснение);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

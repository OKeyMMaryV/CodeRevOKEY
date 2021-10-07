﻿#Область ПрограммныйИнтерфейс

// В процедуре нужно показать диалоговое окно для ввода штрихкода и передать полученные данные в описание оповещения.
//
// Параметры:
//  Оповещение - ОписаниеОповещения - процедура, которую нужно вызвать после ввода штрихкода.
Процедура ПоказатьВводШтрихкода(Оповещение, СтандартнаяОбработка = Истина) Экспорт
	
	СтандартнаяОбработка = Ложь;
	ШтрихкодированиеНоменклатурыБПКлиент.ПоказатьВводШтрихкода(Оповещение);
	
КонецПроцедуры

// В процедуре необходимо реализовать алгоритм обработки
// 
// Параметры:
// 	Форма
// 	ОбработанныеДанные
// 	КэшированныеЗначения
Процедура ПослеОбработкиШтрихкодов(Форма, ОбработанныеДанные, КэшированныеЗначения) Экспорт
	
	СтруктураДействий = ОбработанныеДанные;
	
	ПараметрыСканирования = ШтрихкодированиеИСКлиент.ПараметрыСканирования(Форма);
	Если ШтрихкодированиеИСКлиентСервер.ДопустимВидПродукции(ПараметрыСканирования, ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Алкогольная")) 
		И ОбработанныеДанные.МассивСтрокСАкцизнымиМарками.Количество() > 0 Тогда
		
		ШтрихкодированиеНоменклатурыЕГАИСКлиентПереопределяемый.ОткрытьФормуСчитыванияАкцизнойМаркиПриНеобходимости(Форма, СтруктураДействий);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьФормуПодбораНоменклатурыПоШтрихкодам(НеизвестныеШтрихкоды,
		ФормаВладелец = Неопределено, ОповещениеОЗакрытии = Неопределено) Экспорт
		
	Если ТипЗнч(НеизвестныеШтрихкоды) = Тип("Массив")
		И НеизвестныеШтрихкоды.Количество() = 1 Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ШтрихкодДляРегистрации", НеизвестныеШтрихкоды[0].ШтрихКод);
		ОткрытьФорму("РегистрСведений.ШтрихкодыНоменклатуры.ФормаЗаписи", ПараметрыФормы, ФормаВладелец, Новый УникальныйИдентификатор, , , ОповещениеОЗакрытии);
		
	ИначеЕсли ТипЗнч(НеизвестныеШтрихкоды) = Тип("Массив") Тогда
		ТекстСообщения = НСтр("ru = 'Не определены товары со штрих-кодами:'");
		Первый = Истина;
		Для Каждого НеизвестныйШтрихкод Из НеизвестныеШтрихкоды Цикл
			ТекстСообщения = Стршаблон("%1 %2 %3", ТекстСообщения, ?(Первый, "", ","), НеизвестныйШтрихкод.ШтрихКод);
			Первый = Ложь;
		КонецЦикла;
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, Неопределено);
	Иначе
		ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, Неопределено);
	КонецЕсли;
		
КонецПроцедуры

Процедура ОчиститьКэшированныеШтрихкоды(ДанныеШтрихкодов, КэшированныеЗначения) Экспорт
	
	КэшированныеЗначения.Штрихкоды.Очистить();
	
КонецПроцедуры

// Вызывается после загрузки данных из ТСД. В процедуре нужно проанализировать полученные штрихкоды на предмет сканирования акцизной марки, а также
// обработать штрихкоды, не привязанные к номенклатуре.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма документа, в которой были обработаны штрихкоды,
//  ОбработанныеДанные - Структура - подготовленные ранее данные штрихкодов,
//  КэшированныеЗначения - Структура - используется механизмом обработки изменения реквизитов ТЧ.
Процедура ПослеОбработкиТаблицыТоваровПолученнойИзТСД(Форма, ОбработанныеДанные, КэшированныеЗначения) Экспорт
	
	Возврат;
	
КонецПроцедуры

// В процедуре необходимо указать полное имя формы выбора серии номенклатуры.
//
// Параметры:
//  ПолноеИмяФормыУказанияСерии - Строка - Полное имя формы выбора серии.
Процедура ЗаполнитьПолноеИмяФормыУказанияСерии(ПолноеИмяФормыУказанияСерии) Экспорт


	Возврат;

КонецПроцедуры

// В процедуре нужно реализовать подготовку данных для дальнейшей обработки штрихкодов, полученных из ТСД.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма документа, в которой происходит обработка,
//  ТаблицаТоваров - Массив - полученные данные из ТСД,
//  КэшированныеЗначения - Структура - используется механизмом обработки изменения реквизитов ТЧ,
//  ПараметрыЗаполнения - Структура - параметры заполнения (см. ИнтеграцияЕГАИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти()).
//  СтруктураДействий - Структура - подготовленные данные.
Процедура ПодготовитьДанныеДляОбработкиТаблицыТоваровПолученнойИзТСД(
	Форма, ТаблицаТоваров, КэшированныеЗначения, ПараметрыЗаполнения, СтруктураДействий) Экспорт

	Возврат;

КонецПроцедуры

// В данной процедуре нужно переопределить параметры записи журнала регистрации при отказе ввода кода маркировки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, для которой происходит обработка штрихкода.
//  СтруктураСообщения - Структура:
//   * ИмяСобытия - Строка - Имя события журнала регистрации.
//   * Уровень - Строка - Уровень журнала регистрации. Возможные уровни: "Информация", "Ошибка", "Предупреждение",
//        "Примечание".
//   * Данные - Любая ссылка, Число, Строка, Дата, Булево, Неопределено; Null; Тип - Данные журнала регистрации.
//   * СсылкаНаОбъект - Любая ссылка - Ссылка на объект, на основании которого будут полученные метаданные для записи
//        в журнал регистрации.
//   * КодМаркировки - Строка - Введенный код маркировки. Если значение кода не заполнено - ввод кода маркировки отменен
//        по инициативе пользователя.
Процедура ПриОпределенииИнформацииОбОтказеВводаКодаМаркиДляЖурналаРегистрации(Форма, СтруктураСообщения) Экспорт
	
	Возврат;

КонецПроцедуры

// Получает данные для печати и открывает форму обработки печати этикеток и ценников.
//
// Параметры:
//  ОбъектыПечати        - Структура        - структура с описанием штрихкода.
//  Форма                - УправляемаяФорма - форма-владелец из которой выполняется печать
//  СтандартнаяОбработка - Булево           - признак что требуется печатать из вызывающей функции
Процедура ПечатьЭтикеткиОбувь(ОбъектыПечати, Форма, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

﻿&НаКлиенте
Перем ОбновитьИнтерфейс;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	СоставНабораКонстантФормы    = ПолучитьСтруктуруНабораКонстант(НаборКонстант);
	ВнешниеРодительскиеКонстанты = ПолучитьСтруктуруРодительскихКонстант(СоставНабораКонстантФормы);
	
	РежимРаботы  = Новый Структура;
	РежимРаботы.Вставить("СоставНабораКонстантФормы",    Новый ФиксированнаяСтруктура(СоставНабораКонстантФормы));
	РежимРаботы.Вставить("ВнешниеРодительскиеКонстанты", Новый ФиксированнаяСтруктура(ВнешниеРодительскиеКонстанты));
	
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	СокращенноеНаименование = "";
	ИнтеграцияС1СДокументооборотПереопределяемый.
		ПриОпределенииСокращенногоНаименованияКонфигурации(СокращенноеНаименование);
	Если ЗначениеЗаполнено(СокращенноеНаименование) Тогда
		Элементы.ДеревоОбъектовПредставление.Заголовок = СтрШаблон(
			НСтр("ru = 'Объект %1'"),
			СокращенноеНаименование);
		Элементы.ДекорацияДеревоОбъектов.Заголовок = СтрШаблон(
			НСтр("ru = 'Объекты %1, поддерживающие интеграцию:'"),
			СокращенноеНаименование);
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборотПереопределяемый.ПриОпределенииОбъектовПоддерживающихАвтонастройку(
		ОбъектыСАвтонастройкой);
	
	ЗаполнитьДеревоБезИерархии();
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ОбновитьИнтерфейсПрограммы();
	
КонецПроцедуры

&НаКлиенте
// Обработчик оповещения формы.
//
// Параметры:
//	ИмяСобытия - Строка - обрабатывается только событие Запись_НаборКонстант, генерируемое панелями администрирования.
//	Параметр   - Структура - содержит имена констант, подчиненных измененной константе, "вызвавшей" оповещение.
//	Источник   - Строка - имя измененной константы, "вызвавшей" оповещение.
//
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИнтеграцияС1СДокументооборотом_ИзмененоПравило"
		Или ИмяСобытия = "ИнтеграцияС1СДокументооборотом_СозданоПравило" 
		Или ИмяСобытия = "ИнтеграцияС1СДокументооборотом_ЗаписаноПравило" Тогда
		ЗаполнитьВДеревеПризнакВключена();
		Возврат;
	КонецЕсли;
	
	Если ИмяСобытия <> "Запись_НаборКонстант" Тогда
		Возврат; // такие событие не обрабатываются
	КонецЕсли;
	
	// Если это изменена константа, расположенная в другой форме и влияющая на значения констант этой формы,
	// то прочитаем значения констант и обновим элементы этой формы.
	Если РежимРаботы.ВнешниеРодительскиеКонстанты.Свойство(Источник)
		Или (ТипЗнч(Параметр) = Тип("Структура")
		И ПолучитьОбщиеКлючиСтруктур(Параметр, РежимРаботы.ВнешниеРодительскиеКонстанты).Количество() > 0) Тогда
		
		Прочитать();
		УстановитьДоступность();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьИнтеграциюС1СДокументооборотПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресВебСервиса1СДокументооборотПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыДеревоОбъектов

&НаКлиенте
Процедура ДеревоОбъектовВключенаПриИзменении(Элемент)
	
	ПриИзмененииПризнакаВключена(Элементы.ДеревоОбъектов.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОбъектовПередНачаломИзменения(Элемент, Отказ)
	
	Если Элементы.ДеревоОбъектов.ТекущиеДанные = Неопределено
		Или Элементы.ДеревоОбъектов.ТекущиеДанные.ЭтоГруппа Тогда
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОбъектовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Поле <> Элементы.ДеревоОбъектовТекстСсылки Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ДеревоОбъектов.ТекущиеДанные;
	
	Если ТекущиеДанные.КоличествоПравил > 0 Тогда
		
		ОткрытьСписокПравилСОтбором(ТекущиеДанные);
		
	Иначе // настройка новых правил
			
		Если ТекущиеДанные.ВозможнаАвтонастройка Тогда
			
			НастроитьАвтоматически(ТекущиеДанные);
			
		Иначе
			
			НастроитьВручную(ТекущиеДанные);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВсеПравилаИнтеграции(Команда)
	
	ОткрытьФорму("Справочник.ПравилаИнтеграцииС1СДокументооборотом.Форма.ФормаСписка",, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПравилоВручную(Команда)
	
	НастроитьВручную(Элементы.ДеревоОбъектов.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьДеревоБезИерархии();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьАвторизацию(Команда)
	
	Если Не ЗначениеЗаполнено(НаборКонстант.АдресВебСервиса1СДокументооборот) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не указан адрес веб-сервиса.'"));
	Иначе
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЭтоПользовательНастраивающийИнтеграцию", Истина);
		ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.АвторизацияВ1СДокументооборот", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет дерево интегрируемыми объектами без иерархии.
//
&НаСервере
Процедура ЗаполнитьДеревоБезИерархии()
	
	ОбъектыМетаданных = Новый СписокЗначений;
	
	Типы = ИнтеграцияС1СДокументооборотПовтИсп.ТипыОбъектовПоддерживающихИнтеграцию();
	СоответствиеПравил = СоответствиеПравилТипамОбъектов();
	
	Для Каждого Тип Из Типы Цикл
		
		ОбъектМетаданных = Метаданные.НайтиПоТипу(Тип);
		
		ОбъектыМетаданных.Добавить(ОбъектМетаданных, ОбъектМетаданных.Представление());
		
	КонецЦикла;
	
	ОбъектыМетаданных.СортироватьПоПредставлению();
	
	Дерево = РеквизитФормыВЗначение("ДеревоОбъектов");
	Дерево.Строки.Очистить();
	
	Для Каждого ЭлементСписка Из ОбъектыМетаданных Цикл
		
		Строка = Дерево.Строки.Добавить();
		
		ОбъектМетаданных = ЭлементСписка.Значение;
		Строка.ИмяТипаОбъекта = ОбъектМетаданных.ПолноеИмя();
		Строка.ПредставлениеОбъекта = ЭлементСписка.Представление;
		
		КоличествоПравил = СоответствиеПравил[Строка.ИмяТипаОбъекта];
		
		Если КоличествоПравил <> Неопределено Тогда
			
			Строка.Включена = Истина;
			Строка.КоличествоПравил = КоличествоПравил;
			Строка.ТекстСсылки = СтрШаблон(НСтр("ru = 'Правила (%1)'"), КоличествоПравил);
			
		КонецЕсли;
			
		ПараметрыОтбора = Новый Структура("ИмяТипаОбъекта", Строка.ИмяТипаОбъекта);
		ОбъектСАвтонастройкой = ОбъектыСАвтонастройкой.НайтиСтроки(ПараметрыОтбора);
		Строка.ВозможнаАвтонастройка = (ОбъектСАвтонастройкой.Количество() <> 0);
			
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоОбъектов");
	
КонецПроцедуры

// Возвращает соответствие, содержащее для каждого имени типа количество
// правил и, в случае единственного правила - ссылку на него и представление.
//
Функция СоответствиеПравилТипамОбъектов()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Правила.ТипОбъектаИС КАК ТипОбъектаИС,
		|	КОЛИЧЕСТВО(Правила.Ссылка) КАК КоличествоПравил
		|ИЗ
		|	Справочник.ПравилаИнтеграцииС1СДокументооборотом КАК Правила
		|ГДЕ
		|	НЕ Правила.ПометкаУдаления
		|	И Правила.ТипОбъектаДО <> """"
		|СГРУППИРОВАТЬ ПО
		|	ТипОбъектаИС
		|");
		
	Соответствие = Новый Соответствие;
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока Выборка.Следующий() Цикл
		Соответствие.Вставить(Выборка.ТипОбъектаИС, Выборка.КоличествоПравил);
	КонецЦикла;
	
	Возврат Соответствие;
	
КонецФункции
	
// Заполняет в дереве признак Включена согласно существованию подходящих правил в ИБ.
//
&НаСервере
Процедура ЗаполнитьВДеревеПризнакВключена()
	
	СоответствиеПравил = СоответствиеПравилТипамОбъектов();
	
	ОбработатьСтрокиДерева(ДеревоОбъектов.ПолучитьЭлементы(), СоответствиеПравил);
	
КонецПроцедуры

// Рекурсивно обрабатывает строки дерева, устанавливая признак Включена согласно переданному массиву
// объектов, для которых найдены правила интеграции.
//
&НаСервере
Процедура ОбработатьСтрокиДерева(СтрокиДерева, СоответствиеПравил)
	
	Для Каждого СтрокаДерева Из СтрокиДерева Цикл
		
		Если СтрокаДерева.ЭтоГруппа Тогда
			
			ОбработатьСтрокиДерева(СтрокаДерева.ПолучитьЭлементы(), СоответствиеПравил);
			
		Иначе
			
			КоличествоПравил = СоответствиеПравил[СтрокаДерева.ИмяТипаОбъекта];
			СтрокаДерева.Включена = (КоличествоПравил <> Неопределено);
			
			Если СтрокаДерева.Включена Тогда
				СтрокаДерева.КоличествоПравил = КоличествоПравил;
				СтрокаДерева.ТекстСсылки = СтрШаблон(НСтр("ru = 'Правила (%1)'"),
					СтрокаДерева.КоличествоПравил);
			Иначе
				СтрокаДерева.КоличествоПравил = 0;
				СтрокаДерева.ТекстСсылки = "";
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Выполняет автоматическую настройку интеграции.
//
&НаКлиенте
Процедура НастроитьАвтоматически(ТекущиеДанные)
	
	Если ТекущиеДанные = Неопределено
		Или ТекущиеДанные.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура("ИмяТипаОбъекта", ТекущиеДанные.ИмяТипаОбъекта);
	ОбъектСАвтонастройкой = ОбъектыСАвтонастройкой.НайтиСтроки(ПараметрыОтбора);
	
	ОписаниеВыполняемыхДействий = ОбъектСАвтонастройкой[0].ОписаниеВыполняемыхДействий;
	Если Не ЗначениеЗаполнено(ОписаниеВыполняемыхДействий) Тогда
		ОписаниеВыполняемыхДействий = ОписаниеВыполняемыхДействийПоУмолчанию();
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НастроитьАвтоматическиПродолжение",
		ЭтаФорма,
		ТекущиеДанные.ИмяТипаОбъекта);
	
	ТекстВопроса = ОписаниеВыполняемыхДействий
		+ ?(СтрЗаканчиваетсяНа(ОписаниеВыполняемыхДействий, "."), "", ".")
		+ Символы.ПС
		+ НСтр("ru = 'Создать?'");
		
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить(Истина, НСтр("ru = 'Создать автоматически'"));
	Кнопки.Добавить(Ложь, НСтр("ru = 'Настроить вручную'"));
	Кнопки.Добавить(Неопределено, НСтр("ru = 'Отмена'"));
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки, , Истина);
	
КонецПроцедуры

// Продолжает автоматическую настройку интеграции после вопроса "Вы уверены?".
//
&НаКлиенте
Процедура НастроитьАвтоматическиПродолжение(Результат, ИмяТипаОбъекта) Экспорт
	
	Если Результат = Истина Тогда
	
		ОписаниеОповещения = Новый ОписаниеОповещения("НастроитьАвтоматическиЗавершение",
			ЭтаФорма,
			ИмяТипаОбъекта);
		
		ИнтеграцияС1СДокументооборотКлиент.ПроверитьПодключение(ОписаниеОповещения,,,
			Истина);
		
	ИначеЕсли Результат = Ложь Тогда
		
		НастроитьВручную(Элементы.ДеревоОбъектов.ТекущиеДанные);
		
	КонецЕсли;
	
КонецПроцедуры

// Завершает автоматическую настройку интеграции после проверки подключения.
//
&НаКлиенте
Процедура НастроитьАвтоматическиЗавершение(Результат, ИмяТипаОбъекта) Экспорт
	
	Если Результат <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборотКлиентПереопределяемый.
		НачатьАвтоматическуюНастройкуИнтеграции(ИмяТипаОбъекта);
		
КонецПроцедуры
	
&НаКлиенте
Процедура НастроитьВручную(ТекущиеДанные)
	
	ПараметрыФормы = Новый Структура;
	Если ТекущиеДанные <> Неопределено
		И Не ТекущиеДанные.ЭтоГруппа Тогда
		ПараметрыФормы.Вставить("ТипОбъектаИС", ТекущиеДанные.ИмяТипаОбъекта);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.ПравилаИнтеграцииС1СДокументооборотом.Форма.ФормаЭлемента",
		ПараметрыФормы,
		ЭтаФорма);
			
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокПравилСОтбором(ТекущиеДанные)
	
	ПараметрыФормы = Новый Структура;
	Если ТекущиеДанные <> Неопределено
		И Не ТекущиеДанные.ЭтоГруппа Тогда
		ПараметрыФормы.Вставить("ТипОбъектаИС", ТекущиеДанные.ИмяТипаОбъекта);
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьСписокПравилСОтборомЗавершение",
		ЭтаФорма);
	
	ОткрытьФорму("Справочник.ПравилаИнтеграцииС1СДокументооборотом.Форма.ФормаСписка",
		ПараметрыФормы,
		ЭтаФорма,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокПравилСОтборомЗавершение(Результат, Параметры) Экспорт
	
	ЗаполнитьВДеревеПризнакВключена();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПризнакаВключена(СтрокаДерева)
	
	Если СтрокаДерева.КоличествоПравил = 0 Тогда
		Если СтрокаДерева.Включена Тогда
			СтрокаДерева.ТекстСсылки = НСтр("ru = '<Правила не настроены>'");
		Иначе
			СтрокаДерева.ТекстСсылки = "";
		КонецЕсли;
	Иначе
		// отключение правил.
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ОписаниеВыполняемыхДействийПоУмолчанию()
	
	Возврат НСтр("ru = 'Будет автоматически создано правило интеграции.
		|В 1С:Документообороте будет создан соответствующий вид документа.'");
		
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		#Если НЕ ВебКлиент Тогда
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 1, Истина);
		ОбновитьИнтерфейс = Истина;
		#КонецЕсли
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		
		ОбновитьИнтерфейс = Ложь;
		ОбновитьИнтерфейс();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным, ПеречитыватьФорму = Истина)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат "";
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		Если ЕстьПодчиненныеКонстанты(КонстантаИмя, КонстантаЗначение) 
			И ПеречитыватьФорму Тогда
			Прочитать();
		КонецЕсли;
		
	КонецЕсли;
	
	Если КонстантаИмя = "ИспользоватьИнтеграциюС1СДокументооборот"
		И КонстантаЗначение = Истина Тогда
		
		НаборКонстант["ИспользоватьПроцессыИЗадачи1СДокументооборота"] = Истина;
		СохранитьЗначениеРеквизита("НаборКонстант.ИспользоватьПроцессыИЗадачи1СДокументооборота");
		НаборКонстант["ИспользоватьПрисоединенныеФайлы1СДокументооборота"] = Истина;
		СохранитьЗначениеРеквизита("НаборКонстант.ИспользоватьПрисоединенныеФайлы1СДокументооборота");
		
	КонецЕсли;
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьИнтеграциюС1СДокументооборот" 
		Или РеквизитПутьКДанным = "" Тогда
		
		ЗначениеКонстанты = НаборКонстант.ИспользоватьИнтеграциюС1СДокументооборот;
		
		Элементы.ДеревоОбъектов.Доступность = ЗначениеКонстанты;
		Элементы.СоздатьПравилоВручную.Доступность = ЗначениеКонстанты;
		Элементы.ВсеПравилаИнтеграции.Доступность = ЗначениеКонстанты;
		Элементы.Обновить.Доступность = ЗначениеКонстанты;
		Элементы.НастроитьАвторизацию.Доступность = ЗначениеКонстанты;
		Элементы.АдресВебСервиса1СДокументооборот.Доступность = ЗначениеКонстанты;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСтруктуруНабораКонстант(Набор)
	
	Результат = Новый Структура;
		
	Для Каждого МетаКонстанта Из Метаданные.Константы Цикл
		Если ЕстьРеквизитОбъекта(Набор, МетаКонстанта.Имя) Тогда
			Результат.Вставить(МетаКонстанта.Имя);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ЕстьРеквизитОбъекта(Объект, ИмяРеквизита) Экспорт
	
	КлючУникальностиОбъекта = Новый УникальныйИдентификатор;
	СтруктураРеквизита = Новый Структура(ИмяРеквизита, КлючУникальностиОбъекта);

	ЗаполнитьЗначенияСвойств(СтруктураРеквизита, Объект);
	
	Возврат СтруктураРеквизита[ИмяРеквизита] <> КлючУникальностиОбъекта;
	
КонецФункции

&НаСервере
Функция ЕстьПодчиненныеКонстанты(ИмяРодительскойКонстанты, ЗначениеРодительскойКонстанты) Экспорт
	
	ТаблицаКонстант = ИнтеграцияС1СДокументооборотПереопределяемый.ЗависимостиКонстант();
	
	ПодчиненныеКонстанты = ТаблицаКонстант.НайтиСтроки(
		Новый Структура(
			"ИмяРодительскойКонстанты, ЗначениеРодительскойКонстанты",
			ИмяРодительскойКонстанты, ЗначениеРодительскойКонстанты));
	
	Возврат ПодчиненныеКонстанты.Количество() > 0;
	
КонецФункции

&НаСервере
Функция ПолучитьСтруктуруРодительскихКонстант(СтруктураПодчиненныхКонстант) Экспорт
	
	Результат 		= Новый Структура;
	ТаблицаКонстант = ИнтеграцияС1СДокументооборотПереопределяемый.ЗависимостиКонстант();
	
	Для Каждого ИскомаяКонстанта Из СтруктураПодчиненныхКонстант Цикл
		
		РодительскиеКонстанты = ТаблицаКонстант.НайтиСтроки(
			Новый Структура("ИмяПодчиненнойКонстанты", ИскомаяКонстанта.Ключ));
		
		Для Каждого СтрокаРодителя Из РодительскиеКонстанты Цикл
			
			Если Результат.Свойство(СтрокаРодителя.ИмяРодительскойКонстанты)
				Или СтруктураПодчиненныхКонстант.Свойство(СтрокаРодителя.ИмяРодительскойКонстанты) Тогда
				Продолжить;
			КонецЕсли;
			
			Результат.Вставить(СтрокаРодителя.ИмяРодительскойКонстанты);
			
			РодителиРодителя = ПолучитьСтруктуруРодительскихКонстант(
				Новый Структура(СтрокаРодителя.ИмяРодительскойКонстанты));
			
			Для Каждого РодительРодителя Из РодителиРодителя Цикл
				Результат.Вставить(РодительРодителя.Ключ);
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ПолучитьОбщиеКлючиСтруктур(Структура1, Структура2) Экспорт
	
	Результат = Новый Структура;
	
	Для Каждого КлючИЗначение Из Структура1 Цикл
		Если Структура2.Свойство(КлючИЗначение.Ключ) Тогда
			Результат.Вставить(КлючИЗначение.Ключ);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

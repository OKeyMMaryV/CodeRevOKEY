﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Подготовим структуру для работы с фоновыми заданиями.
	СведенияОДлительнойОперации = Новый Структура();
	СведенияОДлительнойОперации.Вставить("Имя", "");
	СведенияОДлительнойОперации.Вставить("ДлительнаяОперация");

	Если ТребуетсяАкцепт(Запись, ТекущаяДатаСеанса()) ИЛИ (Запись.Состояние = Перечисления.СостоянияЗаявокНаКредит.НеОтправлено) Тогда
		// Запускаем обновление данных из сервиса, чтобы к моменту отправки сообщения (заявка или акцепт) они успели закэшироваться.
		ОбновитьСведенияОСервисе();
	КонецЕсли;	

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
    Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
        МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
        МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
    КонецЕсли;
    // Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Требуется прочитать данные из хранилища значения
	ПодробностиРешенияПрочитаны = Ложь;
	
	ДатаЗаявки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.ЗаявкаНаКредит, "Дата");
	
	КраткоеОписаниеОшибки = НСтр("ru = 'В процессе обмена с банком возникла неизвестная ошибка'");
	Если ЗначениеЗаполнено(Запись.ОписаниеОшибки) Тогда
		КраткоеОписаниеОшибки = Запись.ОписаниеОшибки;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Запись.ОписаниеОшибкиПодробное) Тогда
		Подстроки = Новый Массив;
		Подстроки.Добавить(КраткоеОписаниеОшибки);
		Подстроки.Добавить(Символы.ПС);
		Подстроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Подробнее'"), , , , "ОписаниеОшибкиПодробное"));
		Элементы.НадписьОписаниеОшибки.Заголовок = Новый ФорматированнаяСтрока(Подстроки);
	Иначе
		Элементы.НадписьОписаниеОшибки.Заголовок = КраткоеОписаниеОшибки;
	КонецЕсли;

	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Запись.Новое Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ПометитьКакПрочитанное", 1, Истина);	
	КонецЕсли;	
		
	// Если запустили обновление данных сервиса, то будем ожидать его завершения.
	Если ТребуетсяАкцепт(Запись, ОбщегоНазначенияКлиент.ДатаСеанса()) 
		ИЛИ Запись.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЗаявокНаКредит.НеОтправлено") Тогда

		Если СведенияОСервисе.ТребуетсяПодключениеИнтернетПоддержки Тогда
			ПодключитьОбработчикОжидания("Подключаемый_ПодключитьИнтернетПоддержкуПользователей", 0.5, Истина);
		Иначе
			ОжидатьЗавершениеОбновленияДанныхСервиса();
		КонецЕсли;

	КонецЕсли;	
	
	Элементы.СуммаЗаявки.ОбновитьТекстРедактирования();
	Элементы.СрокЗаявки.ОбновитьТекстРедактирования();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновленоСостояниеЗаявки" 
		И ТипЗнч(Параметр) = Тип("Структура") 
		И Параметр.ЗаявкаНаКредит = Запись.ЗаявкаНаКредит 
		И Параметр.Банк = Запись.Банк Тогда
		Прочитать();
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если НеПроверятьЗаполнение Тогда
		// Проверка заполнения выполняется только при иницировании действия пользователем.
		Возврат;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Запись.СуммаЗаявки) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , НСтр("ru = 'Сумма'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Запись.СуммаЗаявки", , Отказ);

	ИначеЕсли ЗначениеЗаполнено(Запись.СуммаМин) И Запись.СуммаЗаявки < Запись.СуммаМин Тогда
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Запрашиваемая сумма кредита (%1 руб.) меньше минимальной суммы, одобренной банком (%2 руб.)'"),
			Формат(Запись.СуммаЗаявки, "ЧДЦ=2"),
			Формат(Запись.СуммаМин, "ЧДЦ=2"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Запись.СуммаЗаявки", , Отказ);

	ИначеЕсли ЗначениеЗаполнено(Запись.СуммаМакс) И Запись.СуммаЗаявки > Запись.СуммаМакс Тогда
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Запрашиваемая сумма кредита (%1 руб.) больше максимальной суммы, одобренной банком (%2 руб.)'"),
			Формат(Запись.СуммаЗаявки, "ЧДЦ=2"),
			Формат(Запись.СуммаМакс, "ЧДЦ=2"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Запись.СуммаЗаявки", , Отказ);

	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Запись.СрокЗаявки) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, , НСтр("ru = 'Срок'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Запись.СрокЗаявки", , Отказ);

	ИначеЕсли ЗначениеЗаполнено(Запись.СрокМин) И Запись.СрокЗаявки < Запись.СрокМин Тогда
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Запрашиваемый срок кредита (%1 мес.) меньше минимального срока, одобренного банком (%2 мес.)'"),
			Запись.СрокЗаявки,
			Запись.СрокМин);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Запись.СрокЗаявки", , Отказ);

	ИначеЕсли ЗначениеЗаполнено(Запись.СрокМакс) И Запись.СрокЗаявки > Запись.СрокМакс Тогда
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Запрашиваемый срок кредита (%1 мес.) больше максимального срока, одобренного банком (%2 мес.)'"),
			Запись.СрокЗаявки,
			Запись.СрокМакс);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Запись.СрокЗаявки", , Отказ);

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СостояниеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Документооборот = ДокументооборотПоТранзакции(Запись.Транзакция);
	Если НЕ ЗначениеЗаполнено(Документооборот) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Заявка не отправлена'"));
		Возврат;
	КонецЕсли;
	
	// В качестве заголовка формы этапов используем представление заявки.
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Наименование", Заголовок);
	
	УниверсальныйОбменСБанкамиКлиент.ПоказатьФормуСостоянияДокументооборота(Документооборот, ПараметрыФормы);

КонецПроцедуры

&НаКлиенте
Процедура НадписьОписаниеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	ПараметрыОшибки = Новый Структура;
	
	ПараметрыОшибки.Вставить("Заголовок",      СтрШаблон(НСтр("ru='Обмен с %1'"), Запись.Банк));
	ПараметрыОшибки.Вставить("ОписаниеОшибки", Запись.ОписаниеОшибки);
	
	Если ЗначениеЗаполнено(Запись.ОписаниеОшибкиПодробное) Тогда
		ПараметрыОшибки.ОписаниеОшибки = ПараметрыОшибки.ОписаниеОшибки + Символы.ПС + Запись.ОписаниеОшибкиПодробное;
	КонецЕсли;	
	
	ОткрытьФорму("Документ.ЗаявкаНаКредит.Форма.СообщениеОбОшибках", ПараметрыОшибки, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура НадписьЗаявкаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	// Открываем форму заявки на кредит - других ссылок в тексте надписи нет

	КлючеваяОперация = "ОткрытиеФормыЗаявкаНаКредит";
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	
	ОткрытьФорму("Документ.ЗаявкаНаКредит.ФормаОбъекта", Новый Структура("Ключ", Запись.ЗаявкаНаКредит));
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаЗаявкиИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	Запись.СуммаЗаявки = Текст;
	
	Если АннуитетныйГрафикПогашения Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ОбновитьАннуитетныйПлатеж", 0.5, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СрокЗаявкиИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	Запись.СрокЗаявки = Текст;
	
	Если АннуитетныйГрафикПогашения Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ОбновитьАннуитетныйПлатеж", 0.5, Истина);
	КонецЕсли;
	
КонецПроцедуры
 
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтправитьАкцепт(Команда)
	
	НеПроверятьЗаполнение = Ложь;
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;

	Если Модифицированность Тогда
		Записать();
	КонецЕсли;	
	
	ДокументооборотыПолучателей = Новый Соответствие;
	ДокументооборотыПолучателей.Вставить(Запись.Банк, ДокументооборотПоТранзакции(Запись.Транзакция));
	
	ПараметрыПодписанияИОтправки = ЗаявкиНаКредитКлиент.ПараметрыПодписанияИОтправки();
	ПараметрыПодписанияИОтправки.ЗаявкаНаКредит = Запись.ЗаявкаНаКредит;
	ПараметрыПодписанияИОтправки.Организация    = Запись.Организация;
	ПараметрыПодписанияИОтправки.Банки          = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Запись.Банк);
	ПараметрыПодписанияИОтправки.ДокументооборотыПолучателей = ДокументооборотыПолучателей;
	ПараметрыПодписанияИОтправки.ТипТранзакции  = ПредопределенноеЗначение("Перечисление.ТипыТранзакцийОбменаСБанкамиЗаявкиНаКредит.АкцептЗаемщика");
	ПараметрыПодписанияИОтправки.ПараметрыОтбораСертификата = ПараметрыОтбораСертификата(Запись.Организация);
	
	ПараметрыПодписанияИОтправки.ПараметрыНаКлиенте.ВладелецФормы = ЭтотОбъект;
	ПараметрыПодписанияИОтправки.ПараметрыНаКлиенте.ОповещениеОЗавершении = Новый ОписаниеОповещения(
		"ПодписатьИОтправитьЗавершение", ЭтотОбъект);
	
	ЗаявкиНаКредитКлиент.НачатьПодписаниеИОтправку(ПараметрыПодписанияИОтправки);
		
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьЗаявкуПовторно(Команда)
	
	// Если транзакция была создана ранее, но не отправлена, то отправляем существующую транзакцию.
	Если ОтправитьТранзакцииПовторно() Тогда
		ОповеститьОбИзменении(Запись.ИсходныйКлючЗаписи);
		Закрыть();
		Возврат;
	КонецЕсли;	
	
	// Если транзакции не существует, то повторяем цикл отправки полностью.
	ПараметрыПодписанияИОтправки = ЗаявкиНаКредитКлиент.ПараметрыПодписанияИОтправки();
	ПараметрыПодписанияИОтправки.ЗаявкаНаКредит = Запись.ЗаявкаНаКредит;
	ПараметрыПодписанияИОтправки.Организация    = Запись.Организация;
	ПараметрыПодписанияИОтправки.Банки          = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Запись.Банк);
	ПараметрыПодписанияИОтправки.ТипТранзакции  = ПредопределенноеЗначение("Перечисление.ТипыТранзакцийОбменаСБанкамиЗаявкиНаКредит.ЗаявкаНаКредит");
	ПараметрыПодписанияИОтправки.ПараметрыОтбораСертификата = ПараметрыОтбораСертификата(Запись.Организация);
	
	ПараметрыПодписанияИОтправки.ПараметрыНаКлиенте.ВладелецФормы  = ЭтотОбъект;
	ПараметрыПодписанияИОтправки.ПараметрыНаКлиенте.ОповещениеОЗавершении = Новый ОписаниеОповещения(
		"ПодписатьИОтправитьЗавершение", ЭтотОбъект);
	
	ЗаявкиНаКредитКлиент.НачатьПодписаниеИОтправку(ПараметрыПодписанияИОтправки);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция СформироватьЗаголовок(Дата, Сумма, Срок)

	Если ЗначениеЗаполнено(Сумма) И ЗначениеЗаполнено(Срок) Тогда
		Результат = СтрШаблон(НСтр("ru = 'Заявка на кредит %1 руб. на %2'"),
			ЗаявкиНаКредитКлиентСервер.ПредставлениеСуммыКредита(Сумма),
			ЗаявкиНаКредитКлиентСервер.ПредставлениеСрокаКредита(Срок));
	Иначе
		Результат = СтрШаблон(НСтр("ru = 'Заявка на кредит от %1'"), Формат(Дата, "ДЛФ=D"));
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

&НаСервере
Процедура УправлениеФормой()
	
	Заголовок = СформироватьЗаголовок(ДатаЗаявки, Запись.СуммаЗаявки, Запись.СрокЗаявки);
	
	АннуитетныйГрафикПогашения = 
		(Запись.СпособРасчетаСуммыПлатежаПоКредиту = Перечисления.СпособыРасчетаСуммыПлатежаПоКредитамЗаймам.ЕжемесячныйАннуитетныйПлатеж);
	
	Если ЗаявкиНаКредит.ЗаявкаОдобрена(Запись.Состояние) И АннуитетныйГрафикПогашения Тогда
		ОбновитьАннуитетныйПлатеж(АннуитетныйПлатеж, Запись.Ставка, Запись.СуммаЗаявки, Запись.СрокЗаявки);
	КонецЕсли;	
	
	Элементы.Состояние.ЦветТекста   = ЗаявкиНаКредит.ЦветСостояния(Запись.Состояние);
	Элементы.ГруппаОшибка.Видимость = Запись.ЕстьОшибки;
		
	УстановитьТекстНадписьЗаявка();
	
	НастроитьФормуПоСостоянию();
		
КонецПроцедуры	

&НаКлиентеНаСервереБезКонтекста
Функция ТребуетсяАкцепт(Запись, ТекущаяДата)

	// Акцепт возможен только в случае одобрения банком, если срок действия решения банка не истек,
	// и при разборе ответа от банка были корректно распознаны условия банка (определены допустимые сумма и срок)
	Возврат (Запись.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЗаявокНаКредит.Одобрено") 
				И Запись.СрокАктуальности >= НачалоДня(ТекущаяДата)
				И (Запись.СуммаМин <> 0 ИЛИ Запись.СуммаМакс <> 0)
				И (Запись.СрокМин <> 0 ИЛИ Запись.СрокМакс <> 0));
						
КонецФункции 

&НаСервере
Процедура УстановитьТекстНадписьЗаявка()

	РеквизитыЗаявки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Запись.ЗаявкаНаКредит, "Дата, Организация, СуммаДокумента, СрокКредита");
	
	// При отправке акцепта сумма и срок кредита могли быть изменены
	Если Запись.Состояние = Перечисления.СостоянияЗаявокНаКредит.КредитЗапрошен Тогда
		РеквизитыЗаявки.СуммаДокумента = Запись.СуммаЗаявки;
		РеквизитыЗаявки.СрокКредита = Запись.СрокЗаявки;
	КонецЕсли;	
	
	Одобрено = ЗаявкиНаКредит.ЗаявкаОдобрена(Запись.Состояние);
	Отказано = (Запись.Состояние = Перечисления.СостоянияЗаявокНаКредит.Отказано);
	
	ТекстНадписи = "";
	ПараметрыНадписи = Новый Структура; 
	
	Если Одобрено ИЛИ Отказано Тогда
		ТекстНадписи = НСтр("ru='По <a href = ""ЗаявкаНаКредит"">заявке от [ДатаЗаявки][Заемщик]</a> был запрошен кредит на сумму <b>[Сумма] руб</b> и срок <b>[Срок] мес</b>.'");
		ПараметрыНадписи.Вставить("Сумма", РеквизитыЗаявки.СуммаДокумента);
		ПараметрыНадписи.Вставить("Срок", РеквизитыЗаявки.СрокКредита);
	ИначеЕсли Запись.Состояние = Перечисления.СостоянияЗаявокНаКредит.ОжидаетРешения Тогда
		ТекстНадписи = НСтр("ru='<a href = ""ЗаявкаНаКредит"">Заявка от [ДатаЗаявки][Заемщик]</a> получена банком и находится на рассмотрении.'");
	ИначеЕсли Запись.Состояние = Перечисления.СостоянияЗаявокНаКредит.Отправлено Тогда
		ТекстНадписи = НСтр("ru='<a href = ""ЗаявкаНаКредит"">Заявка от [ДатаЗаявки][Заемщик]</a> отправлена, ожидается ответ банка о получении.'");
	Иначе
		// не отправлена
		ТекстНадписи = НСтр("ru='<a href = ""ЗаявкаНаКредит"">Заявка от [ДатаЗаявки][Заемщик]</a> не отправлена в банк.'");
	КонецЕсли;	
		
	ПараметрыНадписи.Вставить("ДатаЗаявки", Формат(РеквизитыЗаявки.Дата, "ДЛФ=D"));
	
	// Добавляем организацию в описание заявки
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		ПараметрыНадписи.Вставить("Заемщик", СтрШаблон(НСтр("ru=', заемщик %1'"), РеквизитыЗаявки.Организация));
	Иначе
		ПараметрыНадписи.Вставить("Заемщик", "");
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(Запись.РегистрационныйНомер) Тогда
		ТекстНадписи = ТекстНадписи + Символы.ПС + НСтр("ru='Номер заявки в банке: [РегистрационныйНомер].'");
		ПараметрыНадписи.Вставить("РегистрационныйНомер", Запись.РегистрационныйНомер);
	КонецЕсли;	
	
	ТекстНадписи = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(ТекстНадписи, ПараметрыНадписи);  
	Элементы.НадписьЗаявка.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(ТекстНадписи);  
		
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстНадписьРешение()

	Если Запись.Состояние = Перечисления.СостоянияЗаявокНаКредит.Отказано Тогда
		
		ПодробностиРешения = ПодробностиРешения();
		
		Если ПодробностиРешения = Неопределено ИЛИ ПодробностиРешения.Количество() = 0 Тогда
			// Если банк не сообщил подробностей отказа, то выведем общую рекомендацию.
			ЧастиНадписи = Новый Массив;
			ЧастиНадписи.Добавить(НСтр("ru='К сожалению, по Вашей заявке было принято отрицательное решение.'"));
			ЧастиНадписи.Добавить(НСтр("ru='Попробуйте подать заявку повторно через несколько месяцев.'"));

			Элементы.НадписьРешение.Заголовок = СтрСоединить(ЧастиНадписи, Символы.ПС);
		Иначе
			// Выводим целиком текст банка в группе дополнительных условий.
			Элементы.НадписьРешение.Видимость = Ложь;
			Элементы.ДополнительныеУсловия.Заголовок           = НСтр("ru = 'Решение банка'");
			Элементы.ДополнительныеУсловия.ОтображатьЗаголовок = Истина;
			Элементы.ДополнительныеУсловия.Отображение         = ОтображениеОбычнойГруппы.ОбычноеВыделение;
		КонецЕсли;	
				
		Возврат;
		
	КонецЕсли;	
	
	ОтветБанкаПоУмолчанию = ОтветБанкаПоУмолчанию();
	
	ПараметрыНадписи = Новый Структура; 
	Если ОтветБанкаПоУмолчанию <> Неопределено И ЗначениеЗаполнено(ОтветБанкаПоУмолчанию.ТекстРешения) Тогда
		// Для банка задан особый текст для отображения решения банка, используем его.
		ТекстНадписи = ОтветБанкаПоУмолчанию.ТекстРешения;
	Иначе
	
		// Установим стандартный текст с описанием решения банка.
		ТекстНадписи = "";
		Если Запись.Состояние = Перечисления.СостоянияЗаявокНаКредит.Готово Тогда
			
			ТекстНадписи = НСтр("ru='Банк подтвердил условия кредита.'");
			
		ИначеЕсли ЗаявкиНаКредит.ЗаявкаОдобрена(Запись.Состояние) Тогда
			
			ТекстНадписи = НСтр("ru='Кредит предварительно одобрен. Сумма <b>[Сумма] руб</b>. Cрок <b>[Срок] мес</b>. Ставка <b>[Ставка] %</b> годовых.'");
			
		КонецЕсли;
		
	КонецЕсли;

	// Подготовим параметры, которые использоваться в тексте решения.
	Если ЗначениеЗаполнено(Запись.СуммаМин)
		И ЗначениеЗаполнено(Запись.СуммаМакс)
		И Запись.СуммаМин = Запись.СуммаМакс Тогда
		ПараметрыНадписи.Вставить("Сумма", Запись.СуммаМакс);
		
	ИначеЕсли ЗначениеЗаполнено(Запись.СуммаМин) И НЕ ЗначениеЗаполнено(Запись.СуммаМакс) Тогда
		ПараметрыНадписи.Вставить("Сумма", СтрШаблон(НСтр("ru='от %1'"), Запись.СуммаМин));

	ИначеЕсли НЕ ЗначениеЗаполнено(Запись.СуммаМин) И ЗначениеЗаполнено(Запись.СуммаМакс) Тогда
		ПараметрыНадписи.Вставить("Сумма", СтрШаблон(НСтр("ru='до %1'"), Запись.СуммаМакс));
		
	Иначе
		ПараметрыНадписи.Вставить("Сумма", СтрШаблон(НСтр("ru='от %1 до %2'"), Запись.СуммаМин, Запись.СуммаМакс));
	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Запись.СрокМин)
		И ЗначениеЗаполнено(Запись.СрокМакс)
		И Запись.СрокМин = Запись.СрокМакс Тогда
	    ПараметрыНадписи.Вставить("Срок", Запись.СрокМакс);
	
	ИначеЕсли ЗначениеЗаполнено(Запись.СрокМин) И НЕ ЗначениеЗаполнено(Запись.СрокМакс) Тогда
        ПараметрыНадписи.Вставить("Срок", СтрШаблон(НСтр("ru='от %1'"), Запись.СрокМин));

	ИначеЕсли НЕ ЗначениеЗаполнено(Запись.СрокМин) И ЗначениеЗаполнено(Запись.СрокМакс) Тогда
        ПараметрыНадписи.Вставить("Срок", СтрШаблон(НСтр("ru='до %1'"), Запись.СрокМакс));
        
	Иначе
		ПараметрыНадписи.Вставить("Срок", СтрШаблон(НСтр("ru='от %1 до %2'"), Запись.СрокМин, Запись.СрокМакс));			

	КонецЕсли;
	
	ПараметрыНадписи.Вставить("Ставка", Запись.Ставка);			
	
	Если ЗначениеЗаполнено(Запись.СрокДействия) Тогда
		ТекстНадписи = ТекстНадписи + Символы.ПС;
		Если ОтветБанкаПоУмолчанию <> Неопределено И ЗначениеЗаполнено(ОтветБанкаПоУмолчанию.ТекстСрокРешения) Тогда
			ТекстНадписи = ТекстНадписи + ОтветБанкаПоУмолчанию.ТекстСрокРешения;
		Иначе
			ТекстНадписи = ТекстНадписи + НСтр("ru='Решение действительно до [СрокДействия].'");
		КонецЕсли;
		ПараметрыНадписи.Вставить("СрокДействия", Формат(Запись.СрокДействия, "ДЛФ=D"));
	КонецЕсли;	
	
	ТекстНадписи = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(ТекстНадписи, ПараметрыНадписи);  
	Элементы.НадписьРешение.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(ТекстНадписи);  
		
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстНадписьИнструкции()
	
	Если Запись.Состояние = Перечисления.СостоянияЗаявокНаКредит.КредитЗапрошен Тогда
		Элементы.НадписьИнструкции.Заголовок = НСтр("ru='От банка ожидается информация по оформлению кредита.'");
		Возврат;
	КонецЕсли;	
	
	РедактируемыеПараметры = Новый Массив; 	// имена редактируемых параметров в винительном падеже: "уточнить СУММУ кредита"
	
	Если Запись.СуммаМин < Запись.СуммаМакс Тогда
		РедактируемыеПараметры.Добавить(НСтр("ru='сумму'"));
	КонецЕсли;	
	
	Если Запись.СрокМин < Запись.СрокМакс Тогда
		РедактируемыеПараметры.Добавить(НСтр("ru='срок'"));
	КонецЕсли;	
	
	// Если банк не предоставил интервалов для выбора, то надпись фиксированная. 
	Если РедактируемыеПараметры.Количество() = 0 Тогда
		Элементы.НадписьИнструкции.Заголовок = НСтр("ru='Ниже Вы можете подтвердить свою заинтересованность в кредите.'");
		Возврат;
	КонецЕсли;	
	
	Элементы.НадписьИнструкции.Заголовок = СтрШаблон(
		НСтр("ru='Ниже Вы можете уточнить %1, чтобы продолжить оформление кредита.'"),
		ОбщегоНазначенияБПКлиентСервер.ПредставлениеСписка(РедактируемыеПараметры));
			
КонецПроцедуры

&НаСервере
Функция ПодробностиРешения()
	
	Если ПодробностиРешенияПрочитаны Тогда
		Возврат ПолучитьИзВременногоХранилища(ПодробностиРешенияАдрес);
	КонецЕсли;	
	
	// Прочитаем подробные условия кредита, полученные в ответе от банка.
	// Также в случае отказа в выдаче кредита здесь может храниться причина отказа. 
	// Хранилище значения (Запись.ПодробностиРешения) недоступно в данных формы, поэтому читаем отдельно менеджером записи.
	МенеджерЗаписи = РегистрыСведений.СостояниеЗаявокНаКредит.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Запись);
	МенеджерЗаписи.Прочитать();
	ПодробностиРешения = МенеджерЗаписи.ПодробностиРешения.Получить(); // см. РегистрыСведений.СостояниеЗаявокНаКредит.НоваяТаблицаДополнительныхСведений()
	
	ПодробностиРешенияАдрес = ПоместитьВоВременноеХранилище(ПодробностиРешения, УникальныйИдентификатор);
	ПодробностиРешенияПрочитаны = Истина;
	
	Возврат ПодробностиРешения;
	
КонецФункции

&НаСервере
Процедура ВывестиДополнительныеУсловия()
	
	ГруппаДополнительныеУсловия = Элементы.ДополнительныеУсловия;
	
	// Сначала очистим существующие элементы.
	// В группе ДополнительныеУсловия все элементы созданы программно, поэтому удаление доступно. 
	Пока ГруппаДополнительныеУсловия.ПодчиненныеЭлементы.Количество() > 0 Цикл
		Элементы.Удалить(ГруппаДополнительныеУсловия.ПодчиненныеЭлементы[0] );
	КонецЦикла;	
			
	ПодробностиРешения = ПодробностиРешения();
	
	Если ТипЗнч(ПодробностиРешения) <> Тип("ТаблицаЗначений") Тогда
		Возврат;
	КонецЕсли;
	
	Индекс = 0;
	
	Для каждого ДополнительноеУсловие Из ПодробностиРешения Цикл
		
		Суффикс = Формат(Индекс, "ЧГ=");
	
		ГруппаДопСвойства = Элементы.Добавить("ГруппаСведение"+Суффикс, Тип("ГруппаФормы"), ГруппаДополнительныеУсловия);
		ГруппаДопСвойства.Вид = ВидГруппыФормы.ОбычнаяГруппа;
		ГруппаДопСвойства.ОтображатьЗаголовок = Ложь;
		ГруппаДопСвойства.Группировка  = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
		ГруппаДопСвойства.Объединенная = Истина;
		
		ИмяЭлементаВидСведений      = "ВидСведения" + Суффикс;
		ИмяЭлементаЗначениеСведений = "ЗначениеСведений" + Суффикс;
		
		ВидСведенийТекст = ДополнительноеУсловие.ВидСведений;
		Если ЗначениеЗаполнено(ВидСведенийТекст) 
			И ЗначениеЗаполнено(ДополнительноеУсловие.ЗначениеСведений)
			И СтрНайти(".,:;!?-+/*^~", Прав(ВидСведенийТекст, 1)) = 0  Тогда
			// Если заполнены обе колонки и в конце текста первой колонки не стоит знак препинания, 
			// то добавим двоеточие, чтобы выглядел как стандартный заголовок надписи.
			ВидСведенийТекст = ВидСведенийТекст + ": ";
		КонецЕсли;
		
		Если (ЗначениеЗаполнено(ВидСведенийТекст) И НЕ ЗначениеЗаполнено(ДополнительноеУсловие.ЗначениеСведений)) Тогда
			// Указана только первая колонка, выводим строку на всю длину.
			ВидСведений           = Элементы.Добавить(ИмяЭлементаВидСведений, Тип("ДекорацияФормы"), ГруппаДопСвойства);
			ВидСведений.Вид       = ВидДекорацииФормы.Надпись;
			ВидСведений.Заголовок = ВидСведенийТекст;

			ВидСведений.АвтоМаксимальнаяШирина   = Ложь;
			ВидСведений.РастягиватьПоГоризонтали = Истина;
			ВидСведений.МаксимальнаяШирина       = 75;
			
		Иначе
			// Выводим обе колонки.
			ВидСведений           = Элементы.Добавить(ИмяЭлементаВидСведений, Тип("ДекорацияФормы"), ГруппаДопСвойства);
			ВидСведений.Вид       = ВидДекорацииФормы.Надпись;
			ВидСведений.Заголовок = ВидСведенийТекст;
			ВидСведений.Ширина    = 16;
			
			ЗначениеСведений                          = Элементы.Добавить(ИмяЭлементаЗначениеСведений, Тип("ДекорацияФормы"), ГруппаДопСвойства);
			ЗначениеСведений.Вид                      = ВидДекорацииФормы.Надпись;
			ЗначениеСведений.Заголовок                = ДополнительноеУсловие.ЗначениеСведений;
			ЗначениеСведений.АвтоМаксимальнаяШирина   = Ложь;
			ЗначениеСведений.РастягиватьПоГоризонтали = Истина;
			ЗначениеСведений.Ширина                   = 0;
			ЗначениеСведений.МаксимальнаяШирина       = 54;
			
		КонецЕсли;
					
		Индекс = Индекс + 1; 
		
	КонецЦикла; 
		
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоСостоянию()
	
	ОжидаетРешения 	= (Запись.Состояние = Перечисления.СостоянияЗаявокНаКредит.ОжидаетРешения);
	НеОтправлено 	= (Запись.Состояние = Перечисления.СостоянияЗаявокНаКредит.НеОтправлено);
	Одобрено 		= ЗаявкиНаКредит.ЗаявкаОдобрена(Запись.Состояние);
	Отказано 		= (Запись.Состояние = Перечисления.СостоянияЗаявокНаКредит.Отказано);
	ТребуетсяАкцепт = ТребуетсяАкцепт(Запись, ТекущаяДатаСеанса());
	СервисДоступен  = (СведенияОСервисе <> Неопределено
						И НЕ СведенияОСервисе.ТребуетсяПодключениеИнтернетПоддержки);
	
	// ОПИСАНИЕ РЕШЕНИЯ
	Элементы.НадписьРешение.Видимость = Одобрено ИЛИ Отказано;
	
	Если Одобрено ИЛИ Отказано Тогда
		УстановитьТекстНадписьРешение();
	КонецЕсли;	
	
	Элементы.НадписьИнструкции.Видимость = ТребуетсяАкцепт ИЛИ Запись.Состояние = Перечисления.СостоянияЗаявокНаКредит.КредитЗапрошен;
	
	Если ТребуетсяАкцепт ИЛИ Запись.Состояние = Перечисления.СостоянияЗаявокНаКредит.КредитЗапрошен Тогда
		УстановитьТекстНадписьИнструкции();
	КонецЕсли;	
	
	// ОСНОВНЫЕ УСЛОВИЯ
	Элементы.ОсновныеУсловия.Видимость = Одобрено;
	Элементы.ГруппаПлатеж.Видимость = Одобрено И АннуитетныйГрафикПогашения;
		
	СуммаВИнтервале = (ТребуетсяАкцепт И Запись.СуммаМин <> Запись.СуммаМакс);
	СрокВИнтервале = (ТребуетсяАкцепт И Запись.СрокМин <> Запись.СрокМакс);
	
	Элементы.СуммаЗаявки.ОтображениеПодсказки = ?(СуммаВИнтервале, ОтображениеПодсказки.ОтображатьСправа, ОтображениеПодсказки.Нет);
	Элементы.СуммаЗаявки.Доступность = СуммаВИнтервале;
	
	Элементы.СрокЗаявки.ОтображениеПодсказки = ?(СрокВИнтервале, ОтображениеПодсказки.ОтображатьСправа, ОтображениеПодсказки.Нет);
	Элементы.СрокЗаявки.Доступность = СрокВИнтервале;
	
	ШаблонОписанияИнтервала   = НСтр("ru='%1 - %2 %3 '");
	ШаблонОписанияИнтервалаОт = НСтр("ru='от %1 %2 '");
	ШаблонОписанияИнтервалаДо = НСтр("ru='до %1 %2 '");
	ТекстВалюта = НСтр("ru='руб.'"); // Поддерживаются только кредиты в рублях.
	ТекстМес    = НСтр("ru='мес.'");
	
	Если ТребуетсяАкцепт Тогда
		
		Если ЗначениеЗаполнено(Запись.СуммаМин) И Запись.СуммаЗаявки < Запись.СуммаМин Тогда
			Запись.СуммаЗаявки = Запись.СуммаМин;
		ИначеЕсли ЗначениеЗаполнено(Запись.СуммаМакс) И Запись.СуммаЗаявки > Запись.СуммаМакс Тогда
			Запись.СуммаЗаявки = Запись.СуммаМакс;
		КонецЕсли;	
		
		Если ЗначениеЗаполнено(Запись.СрокМин) И Запись.СрокЗаявки < Запись.СрокМин Тогда
			Запись.СрокЗаявки = Запись.СрокМин;
		ИначеЕсли ЗначениеЗаполнено(Запись.СрокМакс) И Запись.СрокЗаявки > Запись.СрокМакс Тогда
			Запись.СрокЗаявки = Запись.СрокМакс;
		КонецЕсли;	
		
	КонецЕсли;	
	
	Если СуммаВИнтервале Тогда
		
		Если ЗначениеЗаполнено(Запись.СуммаМин) И ЗначениеЗаполнено(Запись.СуммаМакс) Тогда
			Элементы.СуммаЗаявки.РасширеннаяПодсказка.Заголовок = СтрШаблон(
				ШаблонОписанияИнтервала,
				Запись.СуммаМин,
				Запись.СуммаМакс,
				ТекстВалюта);
		ИначеЕсли ЗначениеЗаполнено(Запись.СуммаМин) Тогда
			Элементы.СуммаЗаявки.РасширеннаяПодсказка.Заголовок = СтрШаблон(
				ШаблонОписанияИнтервалаОт,
				Запись.СуммаМин,
				ТекстВалюта);
		ИначеЕсли ЗначениеЗаполнено(Запись.СуммаМакс) Тогда
			Элементы.СуммаЗаявки.РасширеннаяПодсказка.Заголовок = СтрШаблон(
				ШаблонОписанияИнтервалаДо,
				Запись.СуммаМакс,
				ТекстВалюта);
		КонецЕсли;
		
	КонецЕсли;
	
	Если СрокВИнтервале Тогда
		
		Если ЗначениеЗаполнено(Запись.СрокМин) И ЗначениеЗаполнено(Запись.СрокМакс) Тогда
			Элементы.СрокЗаявки.РасширеннаяПодсказка.Заголовок = СтрШаблон(
				ШаблонОписанияИнтервала,
				Запись.СрокМин,
				Запись.СрокМакс,
				ТекстМес);
		ИначеЕсли ЗначениеЗаполнено(Запись.СрокМин) Тогда
			Элементы.СрокЗаявки.РасширеннаяПодсказка.Заголовок = СтрШаблон(
				ШаблонОписанияИнтервалаОт,
				Запись.СрокМин,
				ТекстМес);
		ИначеЕсли ЗначениеЗаполнено(Запись.СрокМакс) Тогда
			Элементы.СрокЗаявки.РасширеннаяПодсказка.Заголовок = СтрШаблон(
				ШаблонОписанияИнтервалаДо,
				Запись.СрокМакс,
				ТекстМес);
		КонецЕсли;
		
	КонецЕсли;
	
	// ДОПОЛНИТЕЛЬНЫЕ УСЛОВИЯ
	// Если заявка получена банком, здесь может быть срок рассмотрения, а при отказе в кредите - причина отказа	
	ВыводитьДополнительныеУсловия = (ОжидаетРешения ИЛИ Одобрено ИЛИ Отказано);   
	
	Элементы.ДополнительныеУсловия.Видимость = ВыводитьДополнительныеУсловия; 
	Если ВыводитьДополнительныеУсловия Тогда
		ВывестиДополнительныеУсловия();
	КонецЕсли;	
	
	// КНОПКИ
	Элементы.СогласиеСУсловиями.Видимость = ТребуетсяАкцепт;
	Элементы.ОтправитьАкцепт.Видимость = ТребуетсяАкцепт;
	Элементы.ОтправитьАкцепт.КнопкаПоУмолчанию = ТребуетсяАкцепт;
	Элементы.ОтправитьАкцепт.Доступность = Не ТолькоПросмотр И СервисДоступен;	
	
	Элементы.ПодписатьИОтправить.Видимость = НеОтправлено;
	Элементы.ПодписатьИОтправить.КнопкаПоУмолчанию = НеОтправлено;
	Элементы.ПодписатьИОтправить.Доступность = Не ТолькоПросмотр И СервисДоступен;	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьАннуитетныйПлатеж(АннуитетныйПлатеж, Ставка, Сумма, Срок)
	
	Если Срок = 0 ИЛИ Ставка = 0 Тогда
		АннуитетныйПлатеж = 0;
		Возврат;
	КонецЕсли;	
	
	СтавкаВДоляхЗаМесяц = Ставка / 100 / 12;
	АннуитетныйПлатеж = Сумма * СтавкаВДоляхЗаМесяц * Pow((1 + СтавкаВДоляхЗаМесяц), Срок) / (Pow((1 + СтавкаВДоляхЗаМесяц), Срок) - 1);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПометитьКакПрочитанное()
	ПометитьКакПрочитанноеСервер();
	ОповеститьОбИзменении(Запись.ИсходныйКлючЗаписи);
КонецПроцедуры

&НаСервере
Процедура ПометитьКакПрочитанноеСервер()
	
	Попытка
	    // Перед записью читаем данные, чтобы гарантировать актуальность значений
		Прочитать();
		Запись.Новое = Ложь;
		// Отключаем проверку заполнения при автоматической записи, чтобы не путать пользователя сообщениями, которые он не иницировал.
		НеПроверятьЗаполнение = Истина;
		Записать();
		НеПроверятьЗаполнение = Ложь;
	Исключение
		// Никак специально не обрабатываем ошибку - только пишем в журнал
		ЗаписьЖурналаРегистрации(
			НСтр("ru='СостояниеЗаявокНаКредит'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			Метаданные.РегистрыСведений.СостояниеЗаявокНаКредит,
			,
			СтрШаблон(НСтр("ru='Ошибка пометки сообщения как прочтенное: %1'"),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())));
	КонецПопытки;	
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьАннуитетныйПлатеж() 
	ОбновитьАннуитетныйПлатеж(АннуитетныйПлатеж, Запись.Ставка, Запись.СуммаЗаявки, Запись.СрокЗаявки);	
КонецПроцедуры

&НаСервере
Функция ОтправитьТранзакцииПовторно()

	Отбор = Новый Структура;
	Отбор.Вставить("Организация", 	Запись.Организация);
	Отбор.Вставить("Банк", 			Запись.Банк);
	Отбор.Вставить("ТипТранзакции", Перечисления.ТипыТранзакцийОбменаСБанкамиЗаявкиНаКредит.ЗаявкаНаКредит);
	Отбор.Вставить("Статус", 		Перечисления.СтатусыТранзакцийОбменаСБанками.Подготовлена);
	
	Транзакции = УниверсальныйОбменСБанками.ТранзацииПоПредмету(Запись.ЗаявкаНаКредит, Отбор);

	Если Транзакции.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;	
	
	СостояниеПрогресса = ЗаявкиНаКредит.СостояниеПрогрессаПодписанияИОтправки();
	СостояниеПрогресса.ДополнительныеПараметры.ИмяШага = "отправка";
	СостояниеПрогресса.КоличествоДействий = Транзакции.Количество() + 1;
	СостояниеПрогресса.ВыполненоДействий = 2;
	ДлительныеОперации.СообщитьПрогресс(СостояниеПрогресса.ВыполненоДействий / СостояниеПрогресса.КоличествоДействий * 100,
		НСтр("ru = 'Отправка файлов...'"),
		СостояниеПрогресса.ДополнительныеПараметры);
		
	// Результат отправки будет обработан внутри процедуры отправки транзакций
	// (см. УниверсальныйОбменСБанкамиПереопределяемый.ПриОтправкеТранзакции())  
	УниверсальныйОбменСБанками.ОтправитьТранзакцииНаСервер(Перечисления.СервисыОбменаСБанками.ЗаявкиНаКредит, Транзакции);
	
	Возврат Истина;
	
КонецФункции
 
&НаКлиенте
Процедура ПодписатьИОтправитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура")
		ИЛИ НЕ Результат.Свойство("Выполнено") Тогда
		Возврат;
	КонецЕсли;

	Если НЕ Результат.Выполнено Тогда
		Возврат;
	КонецЕсли;

	ОповеститьОбИзменении(Запись.ИсходныйКлючЗаписи);
	Закрыть();

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПараметрыОтбораСертификата(Знач Организация)
	
	ДатаСегодня = ТекущаяДатаСеанса();
	
	СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Организация, ДатаСегодня);
	
	ПараметрыОтбора = ЗаявкиНаКредитКлиентСервер.ПараметрыОтбораСертификата();
	ПараметрыОтбора.Организация = Организация;
	ПараметрыОтбора.Дата        = ДатаСегодня;
	ПараметрыОтбора.ИНН         = СведенияОбОрганизации.ИНН;
	ПараметрыОтбора.ЮридическоеФизическоеЛицо = СведенияОбОрганизации.ЮридическоеФизическоеЛицо;
	
	// ФИО и СНИЛС руководителя юр.лица или самого ИП.
	Если СведенияОбОрганизации.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо Тогда
		ФизЛицо = СведенияОбОрганизации.ИндивидуальныйПредприниматель;
	Иначе
		ФизЛицо = СведенияОбОрганизации.Руководитель;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ФизЛицо) Тогда
		СведенияОРуководителе = УчетЗарплаты.ДанныеФизическихЛиц(, ФизЛицо, ДатаСегодня);
		
		ПараметрыОтбора.Фамилия     = СведенияОРуководителе.Фамилия;
		ПараметрыОтбора.Имя         = СведенияОРуководителе.Имя;
		ПараметрыОтбора.Отчество    = СведенияОРуководителе.Отчество;
		ПараметрыОтбора.СНИЛС       = СведенияОРуководителе.СтраховойНомерПФР;
	КонецЕсли;

	// Сформируем представление отбора для показа на форме выбора.
	ПараметрыОтбора.ПредставлениеОтбора = ЗаявкиНаКредитКлиентСервер.ПредставлениеОтбораСертификата(ПараметрыОтбора);

	Возврат ПараметрыОтбора;
	
КонецФункции

&НаСервереБезКонтекста
Функция ДокументооборотПоТранзакции(Знач Транзакция)

	Если НЕ ЗначениеЗаполнено(Транзакция) Тогда
		Возврат Неопределено;
	КонецЕсли;

	РеквизитыТранзакции = УниверсальныйОбменСБанками.РеквизитыТранзакции(Транзакция);
	Возврат РеквизитыТранзакции.Документооборот;

КонецФункции

#Область ИнтернетПоддержкаПользователей

&НаКлиенте
Процедура Подключаемый_ПодключитьИнтернетПоддержкуПользователей()  

	ОписаниеОповещения = Новый ОписаниеОповещения("ПодключениеИнтернетПоддержкиЗавершение", ЭтотОбъект);	

	ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(ОписаниеОповещения, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПодключениеИнтернетПоддержкиЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		// Повторно получаем данные о сервисе по кредитам и запускаем обновление данных.
		ОбновитьСведенияОСервисе();
		ОжидатьЗавершениеОбновленияДанныхСервиса();
	Иначе
		// Пользователь отказался от подключения либо у него не хватило прав.
		ТекстСообщения = НСтр("ru = 'Для отправки заявок на кредит необходимо подключение Интернет-поддержки'");
		ПоказатьПредупреждение(, ТекстСообщения);
		НастроитьДоступностьЭлементовФормыПослеПодключенияСервиса(Истина);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбновлениеДанныхСервиса

&НаСервере
Процедура ОбновитьСведенияОСервисе()

	Если Параметры.Свойство("СведенияОСервисе") Тогда
		СведенияОСервисе = Параметры.СведенияОСервисе;
	Иначе
		СведенияОСервисе = УниверсальныйОбменСБанками.СведенияОСервисе(Перечисления.СервисыОбменаСБанками.ЗаявкиНаКредит);
	КонецЕсли;
	
	ЗаявкиНаКредит.НачатьОбновлениеДанныхСервиса(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОжидатьЗавершениеОбновленияДанныхСервиса() 

	Если СведенияОДлительнойОперации.ДлительнаяОперация = Неопределено Тогда
		// Фоновое задание не запущено.
		НастроитьДоступностьЭлементовФормыПослеПодключенияСервиса(НЕ СведенияОСервисе.ДанныеАктуальны);
		Возврат;
	КонецЕсли;
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ОповещенияОЗавершении = Новый ОписаниеОповещения("ОбновлениеДанныхСервисаЗавершение", ЭтотОбъект);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		СведенияОДлительнойОперации.ДлительнаяОперация,
		ОповещенияОЗавершении,
		ПараметрыОжидания);

КонецПроцедуры

&НаКлиенте
Процедура ОбновлениеДанныхСервисаЗавершение(Результат, ДополнительныеПараметры) Экспорт

	// Запомним, что текущее фоновое задание завершилось, чтобы можно было переходить к следующим шагам.
	ЕстьОшибки = Ложь;
	Если ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Результат, "Статус", "") = "Ошибка" Тогда
		
		ЕстьОшибки = Истина;
		
		Подстроки = Новый Массив;
		Подстроки.Добавить(НСтр("ru = 'В процессе обновления данных сервиса заявок на кредит возникла ошибка.'"));
		Подстроки.Добавить(Символы.ПС);
		Подстроки.Добавить(Результат.КраткоеПредставлениеОшибки);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрСоединить(Подстроки));
	КонецЕсли;

	СведенияОДлительнойОперации.ДлительнаяОперация = Неопределено; // сбросим признак выполнения
	
	НастроитьДоступностьЭлементовФормыПослеПодключенияСервиса(ЕстьОшибки);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьДоступностьЭлементовФормыПослеПодключенияСервиса(ЕстьОшибки)

	Если ТребуетсяАкцепт(Запись, ОбщегоНазначенияКлиент.ДатаСеанса()) Тогда
		Элементы.ОтправитьАкцепт.Доступность = НЕ ЕстьОшибки И Не ТолькоПросмотр;
	ИначеЕсли Запись.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЗаявокНаКредит.НеОтправлено") Тогда
		Элементы.ПодписатьИОтправить.Доступность = НЕ ЕстьОшибки И Не ТолькоПросмотр;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

&НаСервере
Функция ОтветБанкаПоУмолчанию()

	РеквизитыТранзакции = УниверсальныйОбменСБанками.РеквизитыТранзакции(Запись.Транзакция);
	ДатаАктуальности = ?(ЗначениеЗаполнено(Запись.ДатаИзменения), Запись.ДатаИзменения, ТекущаяДатаСеанса());
	
	Возврат ЗаявкиНаКредит.ОтветБанкаПоУмолчанию(Запись.Банк, РеквизитыТранзакции.ТипТранзакции, ДатаАктуальности);
	
КонецФункции

#КонецОбласти

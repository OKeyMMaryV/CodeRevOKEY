﻿&НаКлиенте
Перем КонтекстЭДОКлиент Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИнициализироватьДанные(Параметры);
	ИзменитьОформлениеФормы(ЭтотОбъект); // Клиент-серверная
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ЗаявленияПоЭлДокументооборотуСПФР", , Объект.Ссылка);
	ИзменитьОформлениеФормы(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьСертификатВОбъект(ТекущийОбъект, ДвДанныеСертификата);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Организации" Тогда
		ОрганизацияПриИзменении(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СкрытьПанельНажатие(Элемент)
	
	БольшеНеПоказыватьИнформационнуюПанель();
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстОшибкиПроверкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьФормуМастераЗаявленияНаПодключение(
		Объект.Организация, 
		ЭтотОбъект,
		,
		ПредопределенноеЗначение("Перечисление.ТипыЗаявленияАбонентаСпецоператораСвязи.Изменение"));
	
КонецПроцедуры
	
&НаКлиенте
Процедура ПолучательПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Объект.Получатель) Тогда
		ПоказатьЗначение(, Объект.Получатель); 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеСертификатаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(ДвДанныеСертификата) Тогда
		
		Адрес = ПоместитьВоВременноеХранилище(ДвДанныеСертификата);
		
		ДополнительныеПараметры = Новый Структура();
		ДополнительныеПараметры.Вставить("Адрес", Адрес);

		КриптографияЭДКОКлиент.ПоказатьСертификат(ДополнительныеПараметры, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидПриИзменении(Элемент)
	
	ИнициализироватьПанельУбранаПользователем();
	ЗаполнитьОператора();
	ПредупредитьЧтоНеВступилВСилу();
	ОрганизацияПриИзменении(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ПриСменеОрганизацииСервер();
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОрганизацияПриИзменении_Завершение", 
		ЭтотОбъект);
	
	ПриСменеОрганизацииКлиент(ОписаниеОповещения, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении_Завершение(ВходящийКонтекст, Результат) Экспорт
	
	ИзменитьОформлениеФормы(ЭтотОбъект);
	ИнициализироватьЗначенияКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ТелефонПриИзменении(Элемент)
	
	ПриИзмененииТекстаРедактированияТелефона(Элемент.ТекстРедактирования, Элемент, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ТелефонИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	ПриИзмененииТекстаРедактированияТелефона(Текст, Элемент, Истина);

КонецПроцедуры

&НаКлиенте
Процедура АдресРегистрацииПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	РедактироватьАдрес(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресФактическийПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	РедактироватьАдрес(Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Печать(Команда)
	
	Если (Модифицированность ИЛИ Параметры.Ключ.Пустая()) И Не Записать() Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстЭДОКлиент.ПечатьЗаявленияПоЭлДокументооборотуСПФР(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИПроверить(Команда)
	
	Если (Модифицированность ИЛИ Параметры.Ключ.Пустая()) 
		И Не Записать() ИЛИ Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;

	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтправить(Команда)
	
	Если НЕ Записать() Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"КомандаОтправить_Завершение", 
		ЭтотОбъект);
	
	КонтекстЭДОКлиент.ОтправкаРегламентированногоОтчетаВПФР(Объект.Ссылка, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтправить_Завершение(Результат, ВходящийКонтекст) Экспорт
	
	ЗапретитьИзменение = ЗапретитьИзменение();
	
	// Перерисовка статуса отправки в форме Отчетность
	КонтекстЭДОКлиент.ОповеститьОбОтправкеЗаявленияВПФР(Объект.Ссылка, Объект.Организация);
	
	Если Открыта() И ЗапретитьИзменение Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура БольшеНеПоказыватьИнформационнуюПанель()
	
	ХранилищеОбщихНастроек.Сохранить(
		"ДокументооборотСКонтролирующимиОрганами_ЗаявленияПоЭлДокументооборотуСПФР_УбратьИнформационнуюПанель",
		XMLСтрока(Объект.Вид),
		Истина);
		
	ИнициализироватьПанельУбранаПользователем();
	ИзменитьОформлениеФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСертификатВОбъект(ТекущийОбъект, ДвДанныеСертификата)
	
	Если Объект.Вид = НаСертификат Тогда
		
		КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
		
		ТекущийОбъект.Сертификат = Новый ХранилищеЗначения(ДвДанныеСертификата);
		ТекущийОбъект.Отпечаток = КонтекстЭДОСервер.ОтпечатокПоДвДаннымСертификата(ДвДанныеСертификата);
		
	Иначе
		
		ТекущийОбъект.Сертификат = Неопределено;
		ТекущийОбъект.Отпечаток = "";
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьСертификат()
	
	Если ЗапретитьИзменение Тогда
		Возврат;
	КонецЕсли;
	
	ПредставлениеСертификатаРеквизит = "";
	Объект.Отпечаток         = "";
	ДвДанныеСертификата      = Неопределено;
	СертификатДатаНачала     = Дата(1,1,1);
	СертификатДатаОкончания  = Дата(1,1,1);
	СертификатПросрочен      = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнициализироватьЗначенияКлиент()
	
	// Телефоны
	Элемент = Элементы.Телефон;
	Элемент.ОбновитьТекстРедактирования();
	ПриИзмененииТекстаРедактированияТелефона(Элемент.ТекстРедактирования, Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииТекстаРедактированияТелефона(Текст, Элемент, ИзмененоВручную = Ложь)
	
	Если ИзмененоВручную Тогда
		Пауза = 1.5;
	Иначе
		Пауза = 0.1;
	КонецЕсли;
	
	Представление = ЭлектроннаяПодписьВМоделиСервисаКлиентСервер.ПолучитьПредставлениеТелефона(Текст);
	
	// Обновляем фактичекое значение
	Если ЗначениеЗаполнено(Представление) Тогда
		// Устанавливаем телефон в виде +7 ХХХ ХХХ-ХХ-ХХ
		Объект.Телефон = Представление;
	Иначе
		// В противном случае, устанавливаем то, что ввел пользователь
		Объект.Телефон = Текст;
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_ОбновитьТелефон");
	ПодключитьОбработчикОжидания("Подключаемый_ОбновитьТелефон", Пауза, Истина);
		
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьТелефон()
	
	Представление = ЭлектроннаяПодписьВМоделиСервисаКлиентСервер.ПолучитьПредставлениеТелефона(Объект.Телефон);
	
	// Меняем отображение на форме
	Если ЗначениеЗаполнено(Представление) Тогда
		Элементы.Телефон.ОбновитьТекстРедактирования();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСменеОрганизацииСервер(Очищать = Истина)
	
	// Очистка заявления
	Если Очищать Тогда
		Для каждого РеквизитЗаявления Из Метаданные.Документы.ЗаявленияПоЭлДокументооборотуСПФР.Реквизиты Цикл
			Если РеквизитЗаявления.Имя <> "Организация"
				И РеквизитЗаявления.Имя <> "Вид"
				И РеквизитЗаявления.Имя <> "Сертификат" Тогда
				Объект[РеквизитЗаявления.Имя] = Неопределено;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Основание = Неопределено;
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		Документы.ЗаявленияПоЭлДокументооборотуСПФР.ЗаполнитьИзБазы(Объект);
	КонецЕсли;
	
	ЗаполнитьОператора();
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьКодОрганаПФР()
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		
		КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
		КонтекстЭДОСервер.ОпределитьОрганПФРОрганизации(Объект.Организация, КодОрганаПФР);

	Иначе
		КодОрганаПФР = "";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОператора()
	
	Оператор = Документы.ЗаявленияПоЭлДокументооборотуСПФР.ПараметрыЗаполненияОператора(Объект.Организация, Объект.Вид);
	ЗаполнитьЗначенияСвойств(Объект, Оператор);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОформлениеФормы(Форма)
	
	ИзменитьОформлениеКнопок(Форма);
	УстановитьЗаголовокФормы(Форма);
	ПрорисоватьСтатус(Форма);
	ИзменитьОформлениеФормыПриЗапретеИзменений(Форма);
	ИзменитьОформлениеФормыВЗависимостиОтВида(Форма);
	ИзменитьОформлениеАдресов(Форма);
	ИзменитьОформлениеСертификата(Форма);
	ИзменитьОформлениеПолучателя(Форма);
	ИзменитьОформлениеОператора(Форма);
	ИзменитьОформлениеОписанияНазначения(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОформлениеОписанияНазначения(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Если Форма.ЗапретитьИзменение
		ИЛИ Форма.ПанельУбранаПользователем
		ИЛИ Объект.Вид = Форма.НаОтключение Тогда
		Элементы.ИнформационнаяПанель.Видимость = Ложь;
	Иначе
		Элементы.ИнформационнаяПанель.Видимость = Истина;
	КонецЕсли;
	
	Если Элементы.ИнформационнаяПанель.Видимость Тогда
		Если Объект.Вид = Форма.НаПодключение Тогда
			Элементы.ТекстНазначения.Заголовок = ДокументооборотСКОКлиентСервер.ПодсказкаКЗаявлениюНаПодключениеПФР();
		ИначеЕсли Объект.Вид = Форма.НаСертификат Тогда
			Элементы.ТекстНазначения.Заголовок = ДокументооборотСКОКлиентСервер.ПодсказкаКЗаявлениюНаСертификатПФР();
		ИначеЕсли Объект.Вид = Форма.НаОтключение Тогда
			Элементы.ТекстНазначения.Заголовок = ДокументооборотСКОКлиентСервер.ПодсказкаКЗаявлениюНаОтключениеПФР();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
	
&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОформлениеПолучателя(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	Элемент  = Элементы.ПолучательПредставление;
	
	Элемент.ЦветТекста = Новый Цвет;
	Форма.ПолучательПредставление = Строка(Объект.Получатель);
	Элементы.ПанельПредупреждения.Видимость = Ложь;
	
	Если ЗначениеЗаполнено(Объект.Организация) И НЕ ЗначениеЗаполнено(Объект.Получатель) Тогда
		
		Если ЗначениеЗаполнено(Форма.КодОрганаПФР) Тогда
			
			Элемент.ЦветТекста = Форма.КрасныйЦвет;
			Форма.ПолучательПредставление = Форма.КодОрганаПФР;

			Если ЗначениеЗаполнено(Форма.УчетнаяЗапись) Тогда
				
				Элементы.ПанельПредупреждения.Видимость = Истина;
				
				Подстрока1 = "Направление ПФР " + Форма.КодОрганаПФР + " не подключено. ";
				
				Оператор = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ЗначениеРеквизитаОбъекта(Форма.УчетнаяЗапись, "СпецОператорСвязи");
				
				Если Оператор = ПредопределенноеЗначение("Перечисление.СпецоператорыСвязи.КалугаАстрал") Тогда
					Подстрока2 = НСтр("ru = 'Для подключения направления '");
					Подстрока3 = Новый ФорматированнаяСтрока(НСтр("ru = 'отправьте'"),,,,"отправьте");
					Подстрока4 = НСтр("ru = ' заявление на подключение направления 1С-Отчетности'");
					
					Элементы.ТекстОшибкиПроверки.Заголовок = Новый ФорматированнаяСтрока(
						Подстрока1,
						Подстрока2,
						Подстрока3,
						Подстрока4);
				Иначе
					Подстрока2 = "Для подключения направления обратитесь к своему оператору эл. документооборота";
					Элементы.ТекстОшибкиПроверки.Заголовок = Подстрока1 + Подстрока2;
				КонецЕсли;

			КонецЕсли;
				
		Иначе
			Элемент.ЦветТекста = Форма.КрасныйЦвет;
			Форма.ПолучательПредставление = НСтр("ru = 'Укажите код органа ПФР в карточке организации'");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОформлениеОператора(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	ЕстьОрганизация  = ЗначениеЗаполнено(Объект.Организация);
	Оператор         = ПараметрыЗаполненияОператора(Объект.Организация, Объект.Вид);
	ЗаполнятьВручную = Оператор.ЗаполнятьВручную;
	
	Элементы.ГруппаОператор.Видимость = ЕстьОрганизация И ЗаполнятьВручную И Объект.Вид = Форма.НаПодключение;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПараметрыЗаполненияОператора(Организация, Вид)
	
	Возврат Документы.ЗаявленияПоЭлДокументооборотуСПФР.ПараметрыЗаполненияОператора(Организация, Вид);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОформлениеСертификата(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	Элемент  = Элементы.ПредставлениеСертификатаНаФорме;
	
	Элемент.ОтображениеПодсказки = ОтображениеПодсказки.Кнопка;
	Элемент.РасширеннаяПодсказка.ЦветТекста = Форма.СерыйЦвет;
	Элемент.РасширеннаяПодсказка.Заголовок  = 
		НСтр("ru = 'Сертификат заполняется автоматически из учетной записи организации.
        |Сертификат необходимо отправить в ПФР не позднее одного дня с момента его получения и не позднее 7 дней до даты истечения предыдущего сертификата.'");
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) 
		ИЛИ НЕ ЗначениеЗаполнено(Форма.УчетнаяЗапись) 
		ИЛИ Форма.ДвДанныеСертификата = Неопределено Тогда
		
		Если Форма.ЗапретитьИзменение Тогда
			Элемент.ЦветТекста  = Форма.КрасныйЦвет;
			Форма.ПредставлениеСертификатаНаФорме = Объект.Отпечаток;
		Иначе
			Элемент.ЦветТекста  = Новый Цвет;
			Форма.ПредставлениеСертификатаНаФорме = "";
		КонецЕсли;
		
	Иначе
		
		// Гиперссылка
		Если Форма.СертификатПросрочен Тогда
			
			Элемент.ЦветТекста  = Форма.СерыйЦвет;
			
			ТекстОшибки = НСтр("ru = 'Срок действия сертификата истек %1'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, Строка(МестноеВремя(Форма.СертификатДатаОкончания)));
			
			Элемент.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
			Элемент.РасширеннаяПодсказка.ЦветТекста  = Форма.КрасныйЦвет;
			Элемент.РасширеннаяПодсказка.Заголовок = ТекстОшибки;
		
		Иначе
			Элемент.ЦветТекста  = Новый Цвет;
		КонецЕсли;
		
		Форма.ПредставлениеСертификатаНаФорме = Форма.ПредставлениеСертификатаРеквизит;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОформлениеАдресов(Форма)
	
	ИзменитьОформлениеАдреса(Форма, "АдресРегистрации", "АдресЮридическийПредставление");
	ИзменитьОформлениеАдреса(Форма, "АдресФактический", "АдресФактическийПредставление");

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОформлениеАдреса(Форма, ИмяРеквизита, ИмяДанных)
	
	Элементы = Форма.Элементы;
	ПредставлениеАдреса = ПредставлениеАдреса(Форма.Объект[ИмяРеквизита]);
	
	Если ЗначениеЗаполнено(Форма.Объект[ИмяРеквизита]) ИЛИ ЗначениеЗаполнено(ПредставлениеАдреса) Тогда
		Элементы[ИмяРеквизита + "Представление"].ЦветТекста = Новый Цвет;
		Форма[ИмяРеквизита + "Представление"] = ПредставлениеАдреса;
	Иначе
		Элементы[ИмяРеквизита + "Представление"].ЦветТекста = Форма.КрасныйЦвет;
		Форма[ИмяРеквизита + "Представление"] = НСтр("ru = 'Заполнить'");
	КонецЕсли;
	
	Если Форма.ЗапретитьИзменение Тогда
		Элементы[ИмяРеквизита + "Представление"].Гиперссылка = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПредставлениеАдреса(ЗначениеАдреса)
	
	Возврат Документы.ЗаявленияПоЭлДокументооборотуСПФР.ПредставлениеАдреса(ЗначениеАдреса);
	
КонецФункции
	
&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОформлениеФормыВЗависимостиОтВида(Форма)
	
	ЭтоЮридическоеЛицо = Форма.ЭтоЮридическоеЛицо;
	Элементы = Форма.Элементы;
	Вид = Форма.Объект.Вид;
	ЭтоСертификат = Вид = Форма.НаСертификат;
	
	Элементы.СведенияОбОрганизации.Видимость = НЕ ЭтоСертификат;
	Элементы.ГруппаРуководитель.Видимость = НЕ ЭтоСертификат;
	Элементы.КонтактнаяИнформация.Видимость = НЕ ЭтоСертификат;
	Элементы.ПредставлениеСертификатаНаФорме.Видимость = ЭтоСертификат;
	
	Если НЕ ЭтоСертификат Тогда
		Если ЭтоЮридическоеЛицо Тогда
			Элементы.СведенияОбОрганизации.Заголовок = НСтр("ru = 'Сведения об организации'");
			Элементы.Фамилия.ШрифтЗаголовка = Новый Шрифт(Элементы.Фамилия.ШрифтЗаголовка,,,Истина);
		Иначе
			Элементы.СведенияОбОрганизации.Заголовок = НСтр("ru = 'Сведения об ИП'");
			Элементы.Фамилия.ШрифтЗаголовка = Новый Шрифт(Элементы.Фамилия.ШрифтЗаголовка,,,Ложь);
		КонецЕсли;
		
		Элементы.КПП.Видимость = ЭтоЮридическоеЛицо;
		Элементы.Слеш1.Видимость = ЭтоЮридическоеЛицо;
		
		Если ЭтоЮридическоеЛицо Тогда
			Элементы.ИНН.Заголовок = НСтр("ru = 'ИНН/КПП организации'");
		Иначе
			Элементы.ИНН.Заголовок = НСтр("ru = 'ИНН организации'");
		КонецЕсли;
		
		Элементы.НаименованиеПолное.Видимость = ЭтоЮридическоеЛицо;
		Элементы.НаименованиеКраткое.Видимость = ЭтоЮридическоеЛицо;
		Элементы.Отступ1.Видимость = ЭтоЮридическоеЛицо;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОформлениеКнопок(Форма)
	
	// Элементы отправки
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	ЗапретитьИзменение = Форма.ЗапретитьИзменение;
	
	Элементы.ФормаКомандаОтправить.Видимость = НЕ ЗапретитьИзменение И НЕ Форма.ЭтоОткрытиеИзМастера;
	
	Элементы.ФормаПровестиИЗакрыть.Видимость = Форма.ЭтоОткрытиеИзМастера;
	Элементы.ФормаПровестиИЗакрыть.КнопкаПоУмолчанию = Форма.ЭтоОткрытиеИзМастера;
	
	Элементы.ФормаСкопировать.Видимость = НЕ Форма.ЭтоОткрытиеИзМастера;

	Элементы.ФормаЗаписать.Видимость = НЕ Форма.ЭтоОткрытиеИзМастера;
	Если Форма.ЗапретитьИзменение Тогда
		Элементы.ФормаЗаписать.ТолькоВоВсехДействиях  = Истина;
	КонецЕсли;
	
	Элементы.Печать.Видимость = 
		ЗначениеЗаполнено(Объект.Вид) 
		И Объект.Вид <> ПредопределенноеЗначение("Перечисление.ВидыЗаявленийНаЭДОВПФР.НаСертификат");

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОформлениеФормыПриЗапретеИзменений(Форма)
	
	// Элементы отправки
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	ЗапретитьИзменение = Форма.ЗапретитьИзменение;
	
	Если Форма.ЗапретитьИзменение Тогда
		
		Элементы.Вид.Видимость = Ложь;
		
		Для каждого Элемент Из Элементы Цикл
			Если ТипЗнч(Элемент) = Тип("ПолеФормы")
				И Элемент.Имя <> "Комментарий" Тогда
				Элемент.ТолькоПросмотр = Истина;
			КонецЕсли;
		КонецЦикла; 

	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПрорисоватьСтатус(Форма)
	
	Объект = Форма.Объект;
	
	ВидКонтролирующегоОргана = ИмяТекущегоТипаПолучателя();
	
	ПараметрыПрорисовкиПанелиОтправки = ДокументооборотСКОВызовСервера.ПараметрыПрорисовкиПанелиОтправки(Объект.Ссылка, Объект.Организация, ВидКонтролирующегоОргана);
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ПрименитьПараметрыПрорисовкиПанелиОтправки(Форма, ПараметрыПрорисовкиПанелиОтправки);
	
	// Для того, что состояние определяется только для записанного объекта, а у нас незаписанный.
	// Поэтому организация может быть пустой в ссылке, а в объекте она уже есть.
	// Поэтому передаем организацию в явном виде
	КомментарийЭтапа = ДокументооборотСКОВызовСервера.ДопКомментарийЭтапаВЗаявленииПФР(Объект.Ссылка, Объект.Организация);
	Если КомментарийЭтапа <> Неопределено Тогда
		Форма.Элементы.КомментарийЭтапа.Видимость = Истина;
		Форма.Элементы.КомментарийЭтапа.Заголовок = КомментарийЭтапа;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовокФормы(Форма)
	
	Если ЗначениеЗаполнено(Форма.Объект.Вид) Тогда
		Заголовок = Строка(Форма.Объект.Вид);
	Иначе
		Заголовок = НСтр("ru = 'Заявление по эл. документообороту с ПФР'");
	КонецЕсли;
	
	Форма.Заголовок = Заголовок + НСтр("ru = ' (электронные трудовые книжки)'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	ИнициализироватьЗначенияКлиент();
	ПредупредитьЧтоНеВступилВСилу();
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПриОткрытииЗавершение_ПослеСменыОрганизации", 
		ЭтотОбъект);
	
	ПриСменеОрганизацииКлиент(ОписаниеОповещения, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение_ПослеСменыОрганизации(Результат, ВходящийКонтекст) Экспорт
	
	ИзменитьОформлениеФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредупредитьЧтоНеВступилВСилу()
	
	Если НЕ ВступилВСилу ИЛИ Объект.Вид = НаСертификат И НЕ СертификатыОтправляются Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ПредупредитьЧтоНеВступилВСилу", 0.5, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПредупредитьЧтоНеВступилВСилу() Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПредупредитьЧтоНеВступилВСилу_ПослеОтвета", 
		ЭтотОбъект);
		
	Если Объект.Вид = НаСертификат Тогда
		Текст = НСтр("ru = 'Вы хотите использовать заявление, которое в настоящее время не принимается ПФР.
                      |Продолжить несмотря на предупреждение?'");
	Иначе
		Текст = НСтр("ru = 'Вы хотите использовать заявление, формат которого еще не вступил в силу, поэтому оно не может быть отправлено в ПФР.
                  |Продолжить несмотря на предупреждение?'");
	КонецЕсли;

	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить(НСтр("ru = 'Нет'"));
	Кнопки.Добавить(НСтр("ru = 'Да'"));
	
	ЗаголовокВопроса = НСтр("ru = 'Заявление не может быть отправлено в ПФР'");
	
	ПоказатьВопрос(ОписаниеОповещения, Текст, Кнопки,, НСтр("ru = 'Нет'"), ЗаголовокВопроса);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредупредитьЧтоНеВступилВСилу_ПослеОтвета(Ответ, ВходящийКонтекст) Экспорт
	
	Если Ответ = НСтр("ru = 'Нет'") Тогда
		Если Открыта() Тогда
			Закрыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьДанные(Параметры)

	ЧерныйЦвет  = Новый Цвет(65, 48, 3);
	СерыйЦвет   = Новый Цвет(87, 87, 87);
	СинийЦвет   = Новый Цвет(28, 85, 174);
	КрасныйЦвет = ЦветаСтиля.ЦветОшибкиПроверкиБРО;
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	КонтекстЭДОСервер.ИнициализироватьВидыЗаявленийНаЭДОВПФР(ЭтотОбъект);
	
	ЭтоНовый = Параметры.Ключ.Пустая();
	Параметры.Свойство("ЭтоОткрытиеИзМастера", ЭтоОткрытиеИзМастера);
	
	Если НЕ ЭтоНовый Тогда
		ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОтметитьКакПрочтенное(Объект.Ссылка);
	КонецЕсли;
	
	ЗапретитьИзменение = ЗапретитьИзменение();
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.СкрытьЭлементыФормыПриИспользованииОднойОрганизации(
			ЭтотОбъект, 
			"Организация");
	КонецЕсли;
		
	Элементы.Вид.Видимость = НЕ ЗначениеЗаполнено(Объект.Вид);
	ВступилВСилу = ДокументооборотСКОВызовСервера.ЗаявленияПоЭДООтправляютсяВПФР();
	СертификатыОтправляются = ДокументооборотСКОВызовСервера.СертификатыОтправляютсяВПФР();
	
	ИнициализироватьПанельУбранаПользователем();
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьПанельУбранаПользователем()
	
	ПанельУбранаПользователем = ХранилищеОбщихНастроек.Загрузить(
		"ДокументооборотСКонтролирующимиОрганами_ЗаявленияПоЭлДокументооборотуСПФР_УбратьИнформационнуюПанель", XMLСтрока(Объект.Вид)) = Истина;
	
КонецПроцедуры

&НаСервере
Функция ЗапретитьИзменение()
	
	СтатусОтправки = СтатусОтправки();
	Возврат ЗначениеЗаполнено(СтатусОтправки) И СтатусОтправки <> Перечисления.СтатусыОтправки.ВКонверте;

КонецФункции

&НаСервере
Функция СтатусОтправки()

	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	Возврат КонтекстЭДОСервер.ПолучитьСтатусОтправкиОбъекта(Объект.Ссылка);

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяТекущегоТипаПолучателя()
	
	Возврат "ПФР";
	
КонецФункции

&НаКлиенте
Процедура РедактироватьАдрес(Элемент)
	
	Имя = СтрЗаменить(Элемент.Имя, "Представление", "");
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"РедактироватьАдрес_Завершение", 
		ЭтотОбъект, 
		Имя);
		
	Если Имя = "АдресРегистрации" Тогда
		АдресИмя = "АдресЮридический";
	Иначе
		АдресИмя = "АдресФактический";
	КонецЕсли;
		
	ДополнительныеПараметры = КонтекстЭДОКлиент.ПараметрыПроцедурыРедактироватьАдрес();
	ДополнительныеПараметры.Вставить("Адрес",             Объект[Имя]);
	ДополнительныеПараметры.Вставить("АдресИмя",          АдресИмя);
	ДополнительныеПараметры.Вставить("Элемент",           Элемент);
	ДополнительныеПараметры.Вставить("Оповещение",        ОписаниеОповещения);
	ДополнительныеПараметры.Вставить("ПринудительноФИАС", Истина);
	ДополнительныеПараметры.Вставить("ТолькоПросмотр",    ЗапретитьИзменение);
	
	КонтекстЭДОКлиент.РедактироватьАдрес(ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьАдрес_Завершение(Результат, Имя) Экспорт
	
	НовыйАдрес = КонтекстЭДОКлиент.РедактироватьАдресКонвертацияРезультата(Результат, Истина);
	
	Если НовыйАдрес.Модифицированность Тогда
		
		Модифицированность = Истина;
		
		Объект[Имя] = НовыйАдрес.Адрес;
		ИзменитьОформлениеАдресов(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСертификат(ВыполняемоеОповещения, ПриОткрытии)
	
	// Обновляем всегда для того, чтобы случайно не отправить старый
	Если Объект.Вид = НаСертификат Тогда
		
		ДополнительныеПараметры = Новый Структура();
		ДополнительныеПараметры.Вставить("ВыполняемоеОповещения", ВыполняемоеОповещения);
		ДополнительныеПараметры.Вставить("ПриОткрытии", ПриОткрытии);
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ЗаполнитьСертификат_Завершение", 
			ЭтотОбъект,
			ДополнительныеПараметры);
			
		КонтекстЭДОКлиент.ДвДанныеСертификатаПоОрганизации(Объект.Организация, ОписаниеОповещения);
		
	Иначе
		Если ЗначениеЗаполнено(ДвДанныеСертификата) Тогда
			ОчиститьСертификат();
			УстановитьМодифицированность(ПриОткрытии);
		КонецЕсли;
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещения);
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура УстановитьМодифицированность(ПриОткрытии)
	
	Если НЕ ПриОткрытии Тогда
		Модифицированность = Истина; // Чтобы запись отрабатывала
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСертификат_Завершение(СвойстваСертификата, ВходящийКонтекст) Экспорт
	
	Если СвойстваСертификата = Неопределено Тогда
		ДвДанныеСертификата = Неопределено;
	Иначе
		ДвДанныеСертификата = СвойстваСертификата.ДвДанныеСертификата;
	КонецЕсли;
	
	Если ДвДанныеСертификата = Неопределено Тогда 
		ОчиститьСертификат();
		УстановитьМодифицированность(ВходящийКонтекст.ПриОткрытии);
	Иначе
		ПредставлениеСертификатаРеквизит = ПредставлениеСертификата(СвойстваСертификата);
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ВходящийКонтекст.ВыполняемоеОповещения);
		
КонецПроцедуры

&НаСервере
Функция ДанныеСертификатаНаСервере(СвойстваСертификата) Экспорт
	
	ДвДанныеСертификата = СвойстваСертификата.ДвДанныеСертификата;
	Сертификат = Новый СертификатКриптографии(ДвДанныеСертификата);
	
	Если Сертификат.Субъект.Свойство("O") Тогда
		Субъект = Сертификат.Субъект["O"]; // Организация
	Иначе
		Субъект = Сертификат.Субъект["CN"]; // ИП
	КонецЕсли;
	
	Издатель = Сертификат.Издатель["O"];

	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("Субъект", Субъект);
	ДополнительныеПараметры.Вставить("Издатель", Издатель);
	
	Возврат ДополнительныеПараметры;
	
КонецФункции

&НаКлиенте
Функция ПредставлениеСертификата(СвойстваСертификата) Экспорт
	
	ДанныеСертификата = ДанныеСертификатаНаСервере(СвойстваСертификата);
	Субъект  = ДанныеСертификата.Субъект;
	Издатель = ДанныеСертификата.Издатель;
	
	СертификатДатаНачала    = МестноеВремя(СвойстваСертификата.ДействителенС);
	СертификатДатаОкончания = МестноеВремя(СвойстваСертификата.ДействителенПо);
	
	СертификатПросрочен = СертификатДатаОкончания < ТекущаяДата();
	
	Представление = НСтр("ru = '%1 (%2-%3), %4'");
	Представление = СтрШаблон(
		Представление,
		Субъект,
		Формат(СертификатДатаНачала, "ДЛФ=D"),
		Формат(СертификатДатаОкончания, "ДЛФ=D"),
		Издатель);
	
	Возврат Представление;
	
КонецФункции

&НаКлиенте
Процедура ПриСменеОрганизацииКлиент(ОписаниеОповещения, ПриОткрытии)
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		
		// Признак юр лица
		ЭтоЮридическоеЛицо = РегламентированнаяОтчетностьВызовСервера.ЭтоЮридическоеЛицо(Объект.Организация);
		
		// Учетная записи
		УчетнаяЗапись = КонтекстЭДОКлиент.УчетнаяЗаписьОрганизации(Объект.Организация);
		
		// Код органа ПФР
		ОпределитьКодОрганаПФР();
		
		// Сертификат
		ЗаполнитьСертификат(ОписаниеОповещения, ПриОткрытии); // асинхронный, ниже него ничего не писать!!!
	
	Иначе
		ЭтоЮридическоеЛицо = Истина;
		УчетнаяЗапись = Неопределено;
		ОчиститьСертификат();
		ОпределитьКодОрганаПФР();
		ВыполнитьОбработкуОповещения(ОписаниеОповещения);
	КонецЕсли;

КонецПроцедуры

#Область ПанельОтправкиВКонтролирующиеОрганы

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтотОбъект, ИмяТекущегоТипаПолучателя());
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтотОбъект, ИмяТекущегоТипаПолучателя());
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтотОбъект, ИмяТекущегоТипаПолучателя());
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтотОбъект, ИмяТекущегоТипаПолучателя());
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтотОбъект, ИмяТекущегоТипаПолучателя());
КонецПроцедуры

#КонецОбласти

#КонецОбласти
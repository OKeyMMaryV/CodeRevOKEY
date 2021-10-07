﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем мРежимОбновленияВиз Экспорт; // Хранит режим обновления перечня виз.

Перем мБылПроведен; // Служит для передачи признака проведения между обработчиками.

Перем мРежимЗаписи; // Служит для передачи режима записи между обработчиками.

Перем мТекущийСтатус Экспорт; // Хранит текущий статус.

Перем мДатаИзмененияСтатуса Экспорт; // Хранит дату изменения статуса.

Перем мАлгоритмИзмененияСтатуса Экспорт; // Хранит текущий алгоритм изменения статуса.

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ВидИнформационнойБазы = Справочники.бит_мпд_ВидыИнформационныхБаз.ТекущаяИнформационнаяБаза;
	ВидОперации = Перечисления.бит_мдм_ВидыОперацийЗаявкаНаИзменение.ВводНового;
	
	Если ЭтоНовый() Тогда
		
		// Заполнение шапки
		бит_ОбщегоНазначения.ЗаполнитьШапкуДокумента(ЭтотОбъект
		                                               , бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь")
													   , Неопределено);
													   
		
	КонецЕсли;	

	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтотОбъект.ВидОперации = Перечисления.бит_мдм_ВидыОперацийЗаявкаНаИзменение.Изменение Тогда
	
		 ПроверяемыеРеквизиты.Добавить("Предмет");
	
	КонецЕсли; 
	
	// Установка настроек обязательности реквизитов
	СтатусДляПоискаНастроек = ?(ЗначениеЗаполнено(мТекущийСтатус), мТекущийСтатус, Справочники.бит_СтатусыОбъектов.ЗаявкаНаИзменение_Черновик);
	бит_ОбщегоНазначения.УстановитьНастройкиОбязательностиРеквизитов(ЭтотОбъект, ПроверяемыеРеквизиты, СтатусДляПоискаНастроек);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;	
	КонецЕсли; 
	
	мРежимЗаписи = РежимЗаписи;
	мБылПроведен = Проведен;	
		
КонецПроцедуры // ПередЗаписью()
	
Процедура ПриЗаписи(Отказ)
		
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
		
	
	
	Если НЕ Отказ Тогда
		
		Если НЕ мРежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
			
			СтатусНач = мТекущийСтатус;			
			УстановитьСтатус(мРежимЗаписи);
			
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры // ПриЗаписи()

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	

	
	// Проверка заполнения модели объекта
	МодельОбъекта = ЭтотОбъект.ПолучитьМодельОбъекта();
	
	Если МодельОбъекта.СтандартныеРеквизиты.Количество() = 0 И МодельОбъекта.Реквизиты.Количество() = 0 Тогда
	
		ТекстСообщения =  НСтр("ru = 'Не внесены новые данные'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения,,,Отказ);
	
	КонецЕсли; 
	
	Если НЕ Отказ Тогда
		
		// Заполним перечень виз
		Если мРежимОбновленияВиз = Перечисления.бит_РежимыОбновленияПеречняВиз.ОбновлятьПриПерепроведении ИЛИ НЕ мБылПроведен Тогда
			
			СтруктураПараметров = Новый Структура;
			бит_Визирование.ОбновитьПереченьВиз(Ссылка,Дата,СтруктураПараметров);
			
		КонецЕсли; 		
		
		// Установим статус.
		УстановитьСтатус(РежимЗаписиДокумента.Проведение);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Если НЕ Отказ Тогда
		
		// Очистим визы.
		бит_Визирование.ОчиститьВсеВизыБезусловно(ЭтотОбъект.Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если ЭтотОбъект.ВидОперации = Перечисления.бит_мдм_ВидыОперацийЗаявкаНаИзменение.ВводНового Тогда
		
		ЭтотОбъект.Предмет = Неопределено;
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Процедура сохраняет модель объекта в хранилище значения.
// 
// Параметры:
//  МодельОбъекта - Структура.
// 
Процедура ЗаписатьМодельОбъекта(МодельОбъекта) Экспорт

	 ЭтотОбъект.ХранилищеМодельОбъекта = Новый ХранилищеЗначения(МодельОбъекта);

КонецПроцедуры // ЗаписатьХранилище()

// Функция извлекает значение модели объекта из хранилища значения.
// 
// Возвращаемое значение:
//  МодельОбъекта - Структура.
// 
Функция ПолучитьМодельОбъекта() Экспорт

	МодельОбъекта = ЭтотОбъект.ХранилищеМодельОбъекта.Получить();
	Если НЕ ТипЗнч(МодельОбъекта) = Тип("Структура") Тогда
	
		МодельОбъекта = Справочники.бит_мдм_ОписанияОбъектовОбмена.МодельОбъектаКонструктор();
	
	КонецЕсли; 
	
	Возврат МодельОбъекта;
	
КонецФункции // ПолучитьМодельОбъекта()

// Процедура сохраняет модель объекта начальную в хранилище значения.
// 
// Параметры:
//  МодельОбъекта - Структура.
// 
Процедура ЗаписатьМодельОбъектаПред(МодельОбъекта) Экспорт

	 ЭтотОбъект.ХранилищеМодельОбъектаПред = Новый ХранилищеЗначения(МодельОбъекта);

КонецПроцедуры // ЗаписатьХранилище()

// Функция извлекает значение модели объекта до начала изменений из хранилища значения.
// 
// Возвращаемое значение:
//  МодельОбъекта - Структура.
// 
Функция ПолучитьМодельОбъектаПред() Экспорт

	МодельОбъекта = ЭтотОбъект.ХранилищеМодельОбъектаПред.Получить();
	Если НЕ ТипЗнч(МодельОбъекта) = Тип("Структура") Тогда
	
		МодельОбъекта = Справочники.бит_мдм_ОписанияОбъектовОбмена.МодельОбъектаКонструктор();
	
	КонецЕсли; 
	
	Возврат МодельОбъекта;
	
КонецФункции // ПолучитьМодельОбъекта()

// Процедура устанавливает статус документа.
// 
// Параметры:
//  РежимЗаписи - РежимЗаписиДокумента.
// 
Процедура УстановитьСтатус(вхРежимЗаписи = Неопределено) Экспорт
	
	СтрАлгоритмы              = бит_уп_Сервер.ПолучитьАлгоритмыОбъектаСистемы(ЭтотОбъект,Перечисления.бит_уп_ВидыАлгоритмов.ИзменениеСтатусовОбъектов);
	мАлгоритмИзмененияСтатуса = СтрАлгоритмы.ИзменениеСтатусовОбъектов;
	
	
	Если НЕ ЗначениеЗаполнено(мАлгоритмИзмененияСтатуса) Тогда
	
		Если вхРежимЗаписи = Неопределено Тогда
			 РежимЗаписи = РежимЗаписиДокумента.Запись;
		Иначе	
			 РежимЗаписи = вхРежимЗаписи;
		КонецЕсли;
		 
		// Вычислим переменные, необходимые для установки статуса.
	    ВсеВизыПолучены = бит_Визирование.ВизыПолучены(Ссылка);
		ЕстьОтклонено   = бит_Визирование.ПринятоРешение(Ссылка, , Справочники.бит_ВидыРешенийСогласования.Отклонено);
		
		
		// Определим статус.		
	    Статус = ОпределитьСтатус(мТекущийСтатус, ВсеВизыПолучены, ЕстьОтклонено, РежимЗаписи);
		
		// Если статус изменился - запишем его
		Если мТекущийСтатус <> Статус Тогда
			
			ДатаИзмененияСтатуса = ТекущаяДата();
			
			ДействиеВыполнено = бит_Визирование.УстановитьСтатусОбъекта(Ссылка
																		, Перечисления.бит_ВидыСтатусовОбъектов.Статус
																		, Статус
																		, мТекущийСтатус
																		, бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь")
																		, ДатаИзмененияСтатуса);
			
			Если ДействиеВыполнено Тогда
				мТекущийСтатус 		  = Статус;
				мДатаИзмененияСтатуса = ДатаИзмененияСтатуса;
			КонецЕсли; 	
			
		КонецЕсли;
	
	Иначе	
		
		// Выполнение установки статуса согласно алгоритма изменения статусов.
		КомментироватьВыполнение = бит_УправлениеПользователямиСервер.ПолучитьЗначениеПоУмолчанию("КомментироватьХодВыполненияАлгоритмовПроцессов",
								бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь"));
			
        РежимСообщений = ?(КомментироватьВыполнение, "Все", "Ошибки");			
			
		СтруктураКонтекст = Новый Структура;
		СтруктураКонтекст.Вставить("ТекущийОбъект", ЭтотОбъект);
		
		бит_уп_Сервер.ВыполнитьАлгоритм(мАлгоритмИзмененияСтатуса,СтруктураКонтекст,РежимСообщений);
		
	КонецЕсли;	
	
КонецПроцедуры // УстановитьСтатус()

// Функция реализует алгоритм определения статуса объекта по-умолчанию.
// 
Функция ОпределитьСтатус(НачальныйСтатус, ВсеВизыПолучены, ЕстьОтклонено, вхРежимЗаписи) Экспорт
	
	РезСтатус = НачальныйСтатус;
	
	Если НачальныйСтатус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаИзменение_Исполнена Тогда
		
		// Если заявка исполнена - статус уже не изменяется.
		
	Иначе	
		
		// Алгоритм изменения статусов для обычного режима.
		Если вхРежимЗаписи = РежимЗаписиДокумента.Проведение 
			ИЛИ (вхРежимЗаписи = РежимЗаписиДокумента.Запись И ЭтотОбъект.Проведен) Тогда
			РезСтатус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаИзменение_Рабочая;
		Иначе
			РезСтатус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаИзменение_Черновик;
		КонецЕсли; 
		
		Если РезСтатус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаИзменение_Рабочая 
			ИЛИ РезСтатус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаИзменение_Утверждена
			ИЛИ РезСтатус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаИзменение_Отклонена Тогда
			
			Если ЕстьОтклонено Тогда
				
				РезСтатус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаИзменение_Отклонена;
				
			Иначе	
				
				Если ВсеВизыПолучены Тогда
					РезСтатус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаИзменение_Утверждена;
				Иначе	
					РезСтатус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаИзменение_Рабочая;
				КонецЕсли; 
				
			КонецЕсли;
			
		КонецЕсли; 
		
	КонецЕсли; 
	
	Возврат РезСтатус;
	
КонецФункции // ОпределитьСтатус()

// Процедура выполняет заявку на удаление - помечает предмет на удаление. 
// В случае успешного выполнения устанавливается статус Исполнена. 
// 
Процедура ИсполнитьЗаявку() Экспорт
	
	флВыполнено = Ложь;
	
	МодельОбъекта = ЭтотОбъект.ПолучитьМодельОбъекта();
	
	Если ЭтотОбъект.ВидОперации = Перечисления.бит_мдм_ВидыОперацийЗаявкаНаИзменение.ВводНового Тогда
		
		Если ЭтотОбъект.СоздатьГруппу Тогда
			СпрОб = Справочники[ЭтотОбъект.ОписаниеОбъекта.Имя].СоздатьГруппу();
		Иначе	
			СпрОб = Справочники[ЭтотОбъект.ОписаниеОбъекта.Имя].СоздатьЭлемент();
		КонецЕсли; 
		
		ЗаполнитьОбъектПоМодели(СпрОб, МодельОбъекта);
		СпрОб.УстановитьНовыйКод();
		
		флВыполнено = бит_ОбщегоНазначения.ЗаписатьСправочник(СпрОб,,"Все");
		
		Если флВыполнено Тогда
		
			 ЭтотОбъект.Предмет = СпрОб.Ссылка;
			 ЭтотОбъект.ОбменДанными.Загрузка = Истина;
			 
			 бит_ОбщегоНазначения.ЗаписатьПровестиДокумент(ЭтотОбъект,РежимЗаписиДокумента.Запись,,"Ошибки");
		
		КонецЕсли; 
		
	ИначеЕсли ЭтотОбъект.ВидОперации = Перечисления.бит_мдм_ВидыОперацийЗаявкаНаИзменение.Изменение Тогда	
		
		СпрОб = ЭтотОбъект.Предмет.ПолучитьОбъект();
		ЗаполнитьОбъектПоМодели(СпрОб, МодельОбъекта);
		флВыполнено = бит_ОбщегоНазначения.ЗаписатьСправочник(СпрОб,,"Все");
		
	КонецЕсли; 
	
	
	Если флВыполнено Тогда
		
		Статус = Справочники.бит_СтатусыОбъектов.ЗаявкаНаИзменение_Исполнена;
		ДатаИзмененияСтатуса = ТекущаяДата();
		
		ДействиеВыполнено = бит_Визирование.УстановитьСтатусОбъекта(ЭтотОбъект.Ссылка
																	, Перечисления.бит_ВидыСтатусовОбъектов.Статус
																	, Статус
																	, мТекущийСтатус
																	, бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь")
																	, ДатаИзмененияСтатуса);
		
		Если ДействиеВыполнено Тогда
			мТекущийСтатус 		  = Статус;
			мДатаИзмененияСтатуса = ДатаИзмененияСтатуса;
		КонецЕсли; 	
		
	КонецЕсли; 

КонецПроцедуры // ИсполнитьЗаявку()

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет объект по модели.
// 
// Параметры:
//  СпрОб - СправочникОбъект
//  МодельОбъекта - Структура
// 
Процедура ЗаполнитьОбъектПоМодели(СпрОб, МодельОбъекта)
	
	МетаОбъект = СпрОб.Метаданные();
	ИспользованиеРеквизита = Метаданные.СвойстваОбъектов.ИспользованиеРеквизита;
	ЭтоГруппа = СпрОб.ЭтоГруппа;
	
	Для каждого КиЗ Из МодельОбъекта.СтандартныеРеквизиты Цикл
		
		Если КиЗ.Ключ = "Код" ИЛИ КиЗ.Ключ = "ЭтоГруппа" Тогда
			
			Продолжить;
			
		КонецЕсли; 
		
		СпрОб[КиЗ.Ключ] = КиЗ.Значение;
		
	КонецЦикла; 
	
	Для каждого КиЗ Из МодельОбъекта.Реквизиты Цикл
		
		Если бит_РаботаСМетаданными.ЕстьРеквизит(КиЗ.Ключ, МетаОбъект) Тогда
			
			МетаРеквизит = МетаОбъект.Реквизиты[КиЗ.Ключ];
			
			Если (МетаРеквизит.Использование = ИспользованиеРеквизита.ДляЭлемента И ЭтоГруппа) 
				ИЛИ (МетаРеквизит.Использование = ИспользованиеРеквизита.ДляГруппы И НЕ ЭтоГруппа)  Тогда
				
				Продолжить;
				
			КонецЕсли; 			
			
			СпрОб[КиЗ.Ключ] = КиЗ.Значение;
			
		КонецЕсли; 
		
	КонецЦикла; 
	
	Для каждого КиЗ Из МодельОбъекта.ТабличныеЧасти Цикл
		
		МодельТЧ = КиЗ.Значение;
		ИмяТЧ = КиЗ.Ключ;		
		
		Если НЕ бит_РаботаСМетаданными.ЕстьТабЧасть(ИмяТЧ, МетаОбъект) Тогда
		
			 Продолжить;
		
		КонецЕсли; 
		
		МетаТЧ = МетаОбъект.ТабличныеЧасти[ИмяТЧ];
		
		Если (МетаТЧ.Использование = ИспользованиеРеквизита.ДляЭлемента И ЭтоГруппа) 
			  ИЛИ (МетаТЧ.Использование = ИспользованиеРеквизита.ДляГруппы И НЕ ЭтоГруппа)  Тогда
		
			 Продолжить;
		
		КонецЕсли; 		
		
		СпрОб[ИмяТЧ].Очистить();
		
		Для каждого МодельСтроки Из МодельТЧ Цикл
			
			НоваяСтрока = СпрОб[ИмяТЧ].Добавить();
			
			Для каждого КиЗР Из МодельСтроки Цикл
				
				Если бит_РаботаСМетаданными.ЕстьРеквизитТабЧасти(КиЗР.Ключ, МетаОбъект, ИмяТЧ) Тогда
					
					НоваяСтрока[КиЗР.Ключ] = КиЗР.Значение;
					
				КонецЕсли; 
				
			КонецЦикла; 
			
		КонецЦикла; 
		
	КонецЦикла; 
	
	СпрОб.ДополнительныеСвойства.Вставить("бит_мдм_РазрешеноИзменение", Истина);
	
КонецПроцедуры // ЗаполнитьОбъектПоМодели()

#КонецОбласти

#Область Инициализация

мРежимОбновленияВиз             = Константы.бит_РежимОбновленияПеречняВиз.Получить();

// Получаем статус и дату изменения статуса для документа.
РезСтруктура = бит_Визирование.ПолучитьСтатусОбъекта(Ссылка);

мТекущийСтатус 		  = ?(ЗначениеЗаполнено(РезСтруктура.Статус), РезСтруктура.Статус, Справочники.бит_СтатусыОбъектов.ПустаяСсылка());
мДатаИзмененияСтатуса = РезСтруктура.Дата;

#КонецОбласти

#КонецЕсли

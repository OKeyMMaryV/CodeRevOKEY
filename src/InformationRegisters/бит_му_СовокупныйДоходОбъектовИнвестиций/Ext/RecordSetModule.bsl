#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем мПериод          Экспорт; // Период движений
Перем мТаблицаДвижений Экспорт; // Таблица движений

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Выполняет движения по регистру.
// 
// Параметры:
//  Нет.
// 
Процедура ВыполнитьДвижения() Экспорт

	мТаблицаДвижений.ЗаполнитьЗначения( мПериод, "Период");
	мТаблицаДвижений.ЗаполнитьЗначения( Истина,  "Активность");

	бит_ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(ЭтотОбъект);

КонецПроцедуры // ВыполнитьДвижения()

#КонецОбласти

#КонецЕсли
